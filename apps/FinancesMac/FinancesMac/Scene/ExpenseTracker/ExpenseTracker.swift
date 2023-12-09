import SwiftUI

extension WindowGroup where Content == ExpenseTracker {
    static var expenseTracker: some Scene {
        WindowGroup(content: { ExpenseTracker() })
    }
}

struct ExpenseTracker: View {
    @State private var currentTab = ExpensesView.description
    @StateObject private var store = ExpenseStore()
    
    var body: some View {
        TabView(selection: $currentTab) {
            ExpensesView(store: store)
                .tag(ExpensesView.description)
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            CategoriesView(store: store)
                .tag(CategoriesView.description)
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Categories")
                }
        }
    }
}

#Preview {
    ExpenseTracker()
}
