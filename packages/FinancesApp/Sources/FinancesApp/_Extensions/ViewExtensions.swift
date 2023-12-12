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
    
    var safeArea: UIEdgeInsets {
        #if os(macOS)
        return .zero
        #else
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
        #endif
    }
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyString(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        return formatter.string(from: .init(value: value)) ?? .init()
    }
}
