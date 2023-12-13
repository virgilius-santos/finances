import SwiftUI
import LocalAuthentication

public extension WindowGroup where Content == LockScreenView {
    static var lockScreen: some Scene {
#if os(macOS)
        WindowGroup(content: { LockScreenView() })
            .windowsStyle(HiddenTitleBarWindowStyle())
#else
        WindowGroup(content: { LockScreenView() })
#endif
    }
}


public struct LockScreenView: View {
    public var body: some View {
        LockView(
            lockType: .both, lockPin: "1234", isEnabled: true, lockWenAppGoesBackground: true,
            content: {
                VStack(spacing: 12, content: {
                    Image(systemName: "globe")
                    
                    Text("Hello World!!!")
                })
            },
            forgotPin: {}
        )
    }
    
    public init(){}
}

struct LockView<Content: View>: View {
    enum LockType: String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First Preference will be biometric, and if it's not available, it will ho for number Lock"
    }
    
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWenAppGoesBackground = true
    
    @ViewBuilder var content: Content
    var forgotPin: () -> Void
    
    @State private var pin = ""
    @State private var animateFiled = false
    @State private var isUnlocked = false
    @State private var noBiometricAccess = false
    
    @Environment(\.scenePhase) var phase
        
    var body: some View {
        GeometryReader { proxy in
            content
                .frame(width: proxy.size.width, height: proxy.size.height)
            
            if isEnabled, !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .ignoresSafeArea()
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentication in settings to unlock the view")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(52)
                            } else {
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
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 44)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: proxy.size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active, lockWenAppGoesBackground {
                isUnlocked = false
                pin = ""
            } else if !isUnlocked, lockType != .both {
                unlockView()
            }
        }
    }
    
    var isBiometricAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func unlockView() {
        Task {
            if isBiometricAvailable && lockType != .number {
                if let result = try? await  LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the view"), result {
                    withAnimation(
                        .snappy, completionCriteria: .logicallyComplete,
                        {
                            isUnlocked = true
                        },
                        completion: {
                            pin = ""
                        }
                    )
                }
            }
            
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    @ViewBuilder
    func NumberPadPinView() -> some View {
        VStack(spacing: 16) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both, isBiometricAvailable {
                        Button(
                            action: {
                                pin = ""
                                noBiometricAccess = false
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
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
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
                if newValue.count == 4 {
                    if lockPin == pin {
                        
                        withAnimation(
                            .snappy, completionCriteria: .logicallyComplete,
                            {
                                isUnlocked = true
                            },
                            completion: {
                                pin = ""
                                noBiometricAccess = !isBiometricAvailable
                            }
                        )
                    } else {
                        pin = ""
                        animateFiled.toggle()
                    }
                }
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
            pin.append("\(number)")
        }
    }
}


#Preview {
    LockScreenView()
}
