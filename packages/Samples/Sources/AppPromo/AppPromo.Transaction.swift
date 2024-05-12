import SwiftUI
import SwiftUIComponents

extension AppPromo {
    struct TransactionView: View {
        @Environment(\.modelContext) var modelContext
        
        let transaction: Transaction
        var showCategory = false
        
        var body: some View {
            CustomSwipeView(
                cornerRadius: 12,
                content: {
                    HStack(spacing: 12) {
                        Text("\(String(transaction.title.prefix(1)))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(TintColor.get(color: transaction.tintColor).value.gradient, in: .circle)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.title)
                                .foregroundStyle(.primary)
                            
                            Text(transaction.remarks)
                                .font(.caption)
                                .foregroundStyle(.primary.secondary)
                            
                            Text(transaction.dateAdded.shortDate)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            
                            if showCategory {
                                Text(transaction.category)
                                    .font(.caption2)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .foregroundStyle(.white)
                                    .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                            }
                        }
                        .hSpacing(.leading)
                        
                        Text(transaction.amount.currencyString)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 12))
                },
                actions: {
                    SwipeAction(tint: .red, icon: "trash", action: {
                        modelContext.delete(transaction)
                    })
                }
            )
        }
    }
}
