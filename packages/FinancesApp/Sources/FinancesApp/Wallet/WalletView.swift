import SwiftUI

public extension WindowGroup where Content == WalletView {
    static var wallet: some Scene {
        WindowGroup(content: { WalletView() })
    }
}

public struct WalletView: View {
    public var body: some View {
        GeometryReader {
            WalletHomeView(screenSize: $0.size)
        }
        .preferredColorScheme(.light)
    }
    
    public init() {}
}

#Preview {
    WalletView()
}
