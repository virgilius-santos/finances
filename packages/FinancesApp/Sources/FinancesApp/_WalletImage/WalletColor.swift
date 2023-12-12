import SwiftUI

extension Color {
    static let bg = Color.init("bg", bundle: Bundle.module)
    static let grayApp = Color.init("gray", bundle: Bundle.module)
    static let blueApp = Color.init("blue", bundle: Bundle.module)
    
    static let background = Color.init("background", bundle: Bundle.module)
    static let icon = Color.init("icon", bundle: Bundle.module)
    static let text = Color.init("text", bundle: Bundle.module)
    
    static let systemBackground = Color(uiColor: .systemBackground)
    
    static let appTint = Color.blueApp
}
