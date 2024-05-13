import SwiftUI
import FoundationUtils
import SwiftData

extension AppPromo {
    public struct Widget: View {
        public init() {}
        
        public var body: some View {
            FilterTransactions(startDate: .now.startOfMonth, endDate: .now.endOfMonth) { transactions in
                CardView(
                    income: transactions.total(category: .income),
                    expense: transactions.total(category: .expense)
                )
            }
            .modelContainer(previewContainer)
        }
    }
}
