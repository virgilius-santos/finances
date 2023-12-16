import SwiftUI
import SwiftUIComponents

public extension WindowGroup where Content == CloudAppView {
    static var cloudApp: some Scene {
        #if os(macOS)
        WindowGroup(content: { CloudAppView() })
            .windowsStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup(content: { CloudAppView() })
        #endif
    }
}

public struct CloudAppView: View {
    public var body: some View {
        CloudAppHome()
    }
    
    public init() {}
}
