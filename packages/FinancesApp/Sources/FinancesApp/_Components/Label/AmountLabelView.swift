import SwiftUI

struct Amount {
    let value: Double
    let style: CurrencyStyle
    let code: String
}

struct AmountLabelView: View {
    let amount: Amount
    
    var body: some View {
        Text(amount.value, format: .currency(code: amount.code))
            .fontWeight(.semibold)
            .foregroundStyle(amount.style.color)
    }
}
