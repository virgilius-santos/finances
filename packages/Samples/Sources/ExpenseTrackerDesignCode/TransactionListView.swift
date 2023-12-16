import SwiftUI

struct TransactionListView: View {
    let transactions: TransactionGroup
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                ForEach(Array(transactions), id: \.key) { section, transactions in
                    Section(
                        content: {
                            ForEach(transactions, id: \.id) { transaction in
                                TransactionRow(transaction: transaction)
                            }
                        },
                        header: {
                            Text(section)
                        }
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}
