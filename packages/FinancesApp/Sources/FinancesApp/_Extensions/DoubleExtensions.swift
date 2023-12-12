import Foundation

extension Double {
    var currencyString: String {
        NumberFormatter.twoFractionDigits.string(from: .init(value: self)) ?? ""
    }
    
    var shortCurrencyString: String {
        NumberFormatter.shortFractionDigits.string(from: .init(value: self)) ?? ""
    }
}
