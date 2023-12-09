import Foundation

extension Category {
    static let allCategories: [Self] = [
        .init(name: "aposentadoria"),
        .init(name: "assinatura"),
        .init(name: "compras"),
        .init(name: "credito"),
        .init(name: "educacao"),
        .init(name: "emergencia"),
        .init(name: "entradas"),
        .init(name: "financiamento"),
        .init(name: "habitacao"),
        .init(name: "mercado"),
        .init(name: "objetivos"),
        .init(name: "poup"),
        .init(name: "provisionado"),
        .init(name: "recuperado"),
        .init(name: "saude"),
        .init(name: "streams"),
        .init(name: "uber")
    ]
}

extension Expense {
    static let mocks: [Self] = [
        .init(title: "Mercado", amount: 500, date: Date(), category: Category.allCategories[9]),
        .init(title: "Panetone", amount: 100, date: Date(), category: Category.allCategories[2])
    ]
}

final class ExpenseTrackerStore: ObservableObject {
    @Published var allExpenses = Expense.mocks
    @Published var categories = Category.allCategories
}
