import Foundation
import FoundationUtils

struct GroupedExpenses: Identifiable, Equatable {
    var id = UUID()
    var date: Date
    var expenses: [Expense]
    
    var title: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        }
        else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        else {
            return date.formatted(date: .abbreviated, time: .omitted)
        }
    }
}

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

struct Category: Equatable, Hashable, Identifiable {
    var id: UUID = .init()
    var name: String
}
