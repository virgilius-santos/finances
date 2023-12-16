import Foundation

struct Overview: Identifiable, Equatable, Hashable {
    enum TransactionType: String, Equatable {
        case income = "Income"
        case expense = "Expense"
    }
    
    struct Value: Identifiable, Equatable, Hashable {
        var id: UUID = .init()
        var month: Date
        var amonut: Double
    }
    
    var id: UUID = .init()
    var category: TransactionType
    var values: [Value]
}
