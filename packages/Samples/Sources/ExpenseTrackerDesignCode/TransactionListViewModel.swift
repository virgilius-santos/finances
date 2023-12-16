import Foundation

final class TransactionListViewModel: ObservableObject {
    @Published var transactions = [Transaction]()
    
    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        transactions = Transaction.transactions
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        TransactionGroup(grouping: transactions) { $0.month }
    }
}
