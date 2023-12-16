import SwiftUI
import LocalAuthentication
import SwiftUIComponents

public struct LockScreenView: View {
    public var body: some View {
        LockView(
            lockType: .both, lockPin: "1234", isEnabled: true, lockWhenAppGoesBackground: true,
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

#Preview {
    LockScreenView()
}
