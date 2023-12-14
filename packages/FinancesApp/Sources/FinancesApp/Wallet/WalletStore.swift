import SwiftUI

struct Overview: Identifiable, Equatable, Hashable {
    enum Category: String, Equatable {
        case income = "Income"
        case expense = "Expense"
    }
    
    struct Value: Identifiable, Equatable, Hashable {
        var id: UUID = .init()
        var month: Date
        var amonut: Double
    }
    
    
    var id: UUID = .init()
    var category: Category
    var values: [Value]
}

extension Overview {
    static var sample: [Overview] = [
        .init(category: .income, values: [
            .init(month: .addMonth(from: -4), amonut: 3550),
            .init(month: .addMonth(from: -3), amonut: 2984.4),
            .init(month: .addMonth(from: -2), amonut: 1987.67),
            .init(month: .addMonth(from: -1), amonut: 2987.3),
        ]),
        .init(category: .expense, values: [
            .init(month: .addMonth(from: -4), amonut: 2871.6),
            .init(month: .addMonth(from: -3), amonut: 1628),
            .init(month: .addMonth(from: -2), amonut: 786),
            .init(month: .addMonth(from: -1), amonut: 1987.3),
        ])
    ]
}

extension Card {
    static var sample: [Card] = [
        .init(name: "Nubank", position: 0, color: Color.purple, balance: "$ 5800,00"),
        .init(name: "C6", position: 1, color: Color.black, balance: "$ 11000,00"),
        .init(name: "Santander", position: 2, color: Color.red, balance: "$ 230,00"),
        .init(name: "Itau", position: 3, color: Color.orange, balance: "$ 50,00"),
        .init(name: "Caixa", position: 4, color: Color.blue, balance: "$ 200,00")
    ]
}

final class WalletStore {
    var cards: [Card] = Card.sample
    
    var expenses: [Expense] = Expense.sample // + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample + Expense.sample
    
    var overview = Overview.sample
}

extension Date {
    static func addMonth(from value: Int) -> Date {
        Calendar.current
            .date(byAdding: .month, value: value, to: .now) ?? .now
    }
}
