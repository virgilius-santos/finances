import SwiftUI

struct CurrencyStyle: Equatable {
    static let expense = Self(color: .red)
    static let income = Self(color: .blue)
    
    
    let color: Color
}

struct CategoryStyle: Equatable, Hashable {
    static let market = Self(color: .blue)
    static let shop = Self(color: .yellow)
    
    
    let color: Color
}

// view extension for better modifier access
extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 44, minHeight: 44)
            .vSpacing()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.systemBackground)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
    }
}
