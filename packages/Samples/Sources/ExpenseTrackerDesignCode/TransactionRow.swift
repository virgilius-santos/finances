import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.icon.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24 , color: Color.icon)
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                
                Text(transaction.category)
                    .font(.footnote)
                    .opacity(0.7)
                
                Text(transaction.date, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
            
            Text(transaction.signedAmount , format: .currency(code: "BRL"))
                .font(.footnote)
                .foregroundStyle(transaction.textColor)
            
        }
    }
    }
