import SwiftUI
import LocalAuthentication

public struct LockView<Content: View>: View {
    public enum LockType: String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First Preference will be biometric, and if it's not available, it will ho for number Lock"
    }
    
    enum ViewState {
        case disabled, locked(LockState)
    }
    
    struct NumberPad {
        let showBackButton: Bool
    }
    
    enum LockState {
        case numberPad(NumberPad)
        case biometric(pinEnabled: Bool)
        case noBiometric
    }
    
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground = true
    
    @ViewBuilder var content: Content
    var forgotPin: () -> Void
    
    private var state: ViewState {
        if isEnabled, !isUnlocked {
            if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                let pinEnabled = lockType == .both
                return .locked(noBiometricAccess ? .noBiometric : .biometric(pinEnabled: pinEnabled))
            }
            let showBackButton = lockType == .both && isBiometricAvailable
            return .locked(.numberPad(.init(
                showBackButton: showBackButton
            )))
        }
        return .disabled
    }
    
    @State private var pin = [Int]()
    @State private var animateFiled = false
    @State private var isUnlocked = false
    @State private var noBiometricAccess = false
    @State private var biometricFail = false
    
    @Environment(\.scenePhase) var phase
        
    public var body: some View {
        GeometryReader { proxy in
            content
                .frame(width: proxy.size.width, height: proxy.size.height)
            
            switch state {
            case .disabled:
                EmptyView()
                
            case .locked(let state):
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .ignoresSafeArea()
                    
                    switch state {
                    case .noBiometric:
                        Text("Enable biometric authentication in settings to unlock the view")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding(52)
                    case let .biometric(pinEnabled):
                        VStack(spacing: 12) {
                            VStack(spacing: 8) {
                                Image(systemName: "lock")
                                    .font(.largeTitle)
                                
                                Text("Tap to Unlock")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                            }
                            .frame(width: 100, height: 100)
                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                            .contentShape(.rect)
                            .onTapGesture {
                                unlockView()
                            }
                            
                            if pinEnabled {
                                Text("Enter Pin")
                                    .frame(width: 100, height: 44)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                       showNumberPad()
                                    }
                            }
                        }
                    case let .numberPad(model):
                        NumberPadPinView(model: model)
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: proxy.size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                tryUnlock()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active {
                lockViewIfNeeded()
            } else {
                tryUnlock()
            }
        }
    }
    
    var isBiometricAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    public init(
        lockType: LockType,
        lockPin: String,
        isEnabled: Bool,
        lockWhenAppGoesBackground: Bool = true,
        @ViewBuilder content: () -> Content,
        forgotPin: @escaping () -> Void
    ) {
        self.lockType = lockType
        self.lockPin = lockPin
        self.isEnabled = isEnabled
        self.lockWhenAppGoesBackground = lockWhenAppGoesBackground
        self.content = content()
        self.forgotPin = forgotPin
    }
    
    func lockViewIfNeeded() {
        biometricFail = false
        guard lockWhenAppGoesBackground else { return }
        lockView()
    }
    
    func lockView() {
        noBiometricAccess = false
        isUnlocked = false
        pin = .init()
    }
    
    func tryUnlock() {
        guard !isUnlocked else { return }
        if lockType == .biometric {
            unlockView()
            return
        }
        if !biometricFail {
            unlockView()
        }
    }
    
    func unlockView() {
        Task {
            if isBiometricAvailable && lockType != .number {
                do {
                    let result = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the view")
                    biometricFail = !result
                    if result {
                        withAnimation(
                            .snappy, completionCriteria: .logicallyComplete,
                            {
                                isUnlocked = true
                            },
                            completion: {
                                pin = .init()
                            }
                        )
                    }
                } catch {
                    biometricFail = true
                    lockView()
                }
            }
            
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    func showNumberPad() {
        noBiometricAccess = true
    }
    
    func unlockViewByPin() {
        if pin.count == 4 {
            if lockPin == pin.map(String.init).reduce("", +) {
                withAnimation(
                    .snappy, completionCriteria: .logicallyComplete,
                    {
                        isUnlocked = true
                    },
                    completion: {
                        pin = .init()
                        noBiometricAccess = !isBiometricAvailable
                    }
                )
            } else {
                pin = .init()
                animateFiled.toggle()
            }
        }
    }
    
    @ViewBuilder
    func NumberPadPinView(model: NumberPad) -> some View {
        VStack(spacing: 16) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if model.showBackButton {
                        Button(
                            action: {
                                lockView()
                            },
                            label: {
                                Image(systemName: "arrow.left")
                                    .font(.title3)
                                    .contentShape(.rect)
                                    .frame(width: 44, height: 44)
                            }
                        )
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 52, height: 56)
                        .overlay {
                            if pin.count > index {
                                Text("\(pin[index])")
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(
                initialValue: CGFloat.zero,
                trigger: animateFiled,
                content: { content, value in
                    content.offset(x: value)
                },
                keyframes: { _ in
                    KeyframeTrack {
                        CubicKeyframe(32, duration: 0.08)
                        CubicKeyframe(-32, duration: 0.08)
                        CubicKeyframe(28, duration: 0.08)
                        CubicKeyframe(-28, duration: 0.08)
                        CubicKeyframe(0, duration: 0.08)
                    }
                }
            )
            .padding(.top, 16)
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forgot Pin?", action: forgotPin)
                    .font(.caption)
                    .frame(minWidth: 44, minHeight: 44)
                    .foregroundStyle(.white)
                    .offset(y: 44)
                    .padding(.top, 8)
                
            })
            .frame(maxHeight: .infinity)
            
            GeometryReader(content: { geometry in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        ButtonPad(action: { add(number: number) }, label: {
                            Text("\(number)")
                        })
                    }
                    
                    ButtonPad(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                    })
                    
                    ButtonPad(action: { add(number: 0) }, label: {
                        Text("0")
                    })
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            })
            .onChange(of: pin) { oldValue, newValue in
                unlockViewByPin()
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    
    @ViewBuilder
    func ButtonPad(action: @escaping () -> Void, @ViewBuilder label: () -> some View) -> some View {
        Button(action: action, label: {
            label()
                .font(.title)
                .frame(minWidth: 44, minHeight: 44)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .containerShape(.rect)
        })
        .tint(.white)
    }
    
    func add(number: Int) {
        if pin.count <= 4 {
            pin.append(number)
        }
    }
}
