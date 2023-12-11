import Foundation

final class ExpensesViewModel: ObservableObject {
    @Published var groupedExpenses: [GroupedExpenses] = []
    
    var categories: [Category] {
        store.categories.sorted(by: { $0.name < $1.name })
    }
    
    var emptyContent: Bool {
        store.allExpenses.isEmpty || groupedExpenses.isEmpty
    }
    
    @Published var store: ExpenseTrackerStore
    
    init(store: ExpenseTrackerStore) {
        self.store = store
    }
    
    func load() {
        createGroupedExpenses(store.allExpenses)
    }
    
    @MainActor
    func update(groupedExpenses: [GroupedExpenses]) {
        self.groupedExpenses = groupedExpenses
    }
    
    func createGroupedExpenses(_ expenses: [Expense]) {
        guard groupedExpenses.isEmpty else { return }
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) { expense in
                Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
            }
            
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let newGroupedExpenses = sortedDict.compactMap { dict in
                let date = Calendar.current.date(from: dict.key) ?? .init()
                return GroupedExpenses(date: date, expenses: dict.value)
            }
            
            await self.update(groupedExpenses: newGroupedExpenses)
        }
    }
    
    func remove(expense: Expense, in group: GroupedExpenses) {
        store.allExpenses.removeAll(where: { $0 == expense })
        guard let index = groupedExpenses.firstIndex(of: group) else {
            return
        }
        groupedExpenses[index].expenses.removeAll(where: { $0 == expense })
        if groupedExpenses[index].expenses.isEmpty {
            groupedExpenses.remove(at: index)
        }
    }
}
