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
