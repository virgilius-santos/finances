import SwiftUI

struct Amount: Equatable {
    let value: Double
    let style: CurrencyStyle
    var code: String = "BRL"
}

struct AmountLabelView: View {
    let amount: Amount
    
    var body: some View {
        Text(amount.value, format: .currency(code: amount.code))
            .fontWeight(.semibold)
            .foregroundStyle(amount.style.color)
    }
}
