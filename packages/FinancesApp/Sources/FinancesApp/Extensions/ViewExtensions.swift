import SwiftUI

extension View {
    var mainRect: CGRect {
        #if os(macOS)
        return NSScreen.main!.visibleFrame
        #else
        return UIScreen.main.bounds
        #endif
    }
    
    var isMacOS: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
