import SwiftUI

public struct CurrencyStyle: Equatable {
    public static let expense = Self(color: .red)
    public static let income = Self(color: .blue)
    
    public let color: Color
    
    public init(color: Color) {
        self.color = color
    }
}

public struct CategoryStyle: Equatable, Hashable {
    public static let market = Self(color: .blue)
    public static let shop = Self(color: .yellow)
    
    public let color: Color
    
    public init(color: Color) {
        self.color = color
    }
}
