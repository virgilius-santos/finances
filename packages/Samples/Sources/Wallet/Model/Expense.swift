import Foundation
import FoundationUtils

struct Expense: Equatable, Hashable, Identifiable {
    var id = UUID()
    var title: String
    var amount: Double
    var date: Date
    var category: Category
    
    var currencyString: String {
        amount.currencyString
    }
}
