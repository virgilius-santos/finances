import Foundation

final class AddExpenseViewModel: ObservableObject {
    @Published var title = ""
    @Published var date = Date()
    @Published var amount = CGFloat.zero
    @Published var category: Category?
    
    var allCategories: [Category]
    
    var isCompleted: Bool {
        !(title.isEmpty || amount.isZero || category == nil)
    }
    
    init(title: String = "", date: Date = Date(), amount: CGFloat = CGFloat.zero, category: Category? = nil, allCategories: [Category]) {
        self.title = title
        self.date = date
        self.amount = amount
        self.category = category
        self.allCategories = allCategories
    }
}
