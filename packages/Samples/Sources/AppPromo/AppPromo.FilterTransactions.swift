import SwiftUI
import SwiftData

extension AppPromo {
    struct FilterTransactions<Content: View>: View {
        
        var content: ([Transaction]) -> Content
        
        @Query(animation: .snappy) private var transactions: [Transaction]
        
        init(
            category: Category?,
            searchText: String,
            @ViewBuilder content: @escaping ([Transaction]) -> Content
        ) {
            let categoryValue = category?.rawValue ?? ""
            let predicate = #Predicate<Transaction> { transaction in
                (
                    transaction.title.localizedStandardContains(searchText) || transaction.remarks.localizedStandardContains(searchText)
                ) && (
                    categoryValue.isEmpty ? true : transaction.category == categoryValue
                )
            }
            _transactions = Query(
                filter: predicate,
                sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)],
                animation: .snappy)
            self.content = content
        }
        
        init(
            startDate: Date,
            endDate: Date,
            @ViewBuilder content: @escaping ([Transaction]) -> Content
        ) {
            let predicate = #Predicate<Transaction> { transaction in
                transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
            }
            _transactions = Query(
                filter: predicate,
                sort: [SortDescriptor(\Transaction.dateAdded, order: .reverse)],
                animation: .snappy)
            self.content = content
        }
        
        var body: some View {
            content(transactions)
        }
    }
}
