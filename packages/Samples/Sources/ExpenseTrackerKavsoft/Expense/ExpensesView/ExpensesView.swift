import SwiftUI
import SwiftUIComponents

struct ExpensesView: View {
    static var description = "\(Self.self)"
    
    @StateObject private var viewModel: ExpensesViewModel
    @State private var addExpense = false
    
    var body: some View {
        NavigationStack {
            ExpensesList(
                groupedExpenses: $viewModel.groupedExpenses,
                deleteAction: { expense, group in
                    withAnimation {
                        viewModel.remove(expense: expense, in: group)
                    }
                }
            )
            .navigationTitle("Expenses")
            .overlay {
                if viewModel.emptyContent {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton.addButton(action: { addExpense.toggle() })
                }
            }
            .onChange(of: viewModel.store.allExpenses) { oldValue, newValue in
                viewModel.createGroupedExpenses(newValue)
            }
            .sheet(isPresented: $addExpense, content: {
                AddExpenseView(categories: viewModel.categories, result: { viewModel.store.allExpenses.append($0) })
            })
            .onAppear {
                viewModel.load()
            }
        }
    }
    
    init(store: ExpenseTrackerStore) {
        _viewModel = .init(wrappedValue: ExpensesViewModel(store: store))
    }
}

struct ExpensesList: View {
    @Binding var groupedExpenses: [GroupedExpenses]
    var deleteAction: (Expense, GroupedExpenses) -> Void
    
    var body: some View {
        List {
            ForEach(groupedExpenses) { group in
                Section(group.title) {
                    ForEach(group.expenses) { expense in
                        ExpensesCard(expense: expense)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(
                                    action: { deleteAction(expense, group) },
                                    label: { Image(systemName: "trash") }
                                )
                            }
                    }
                }
            }
        }
    }
}

struct ExpensesCard: View {
    var expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.title)
            
            Spacer(minLength: 5)
            
            Text(expense.currencyString)
                .font(.title3.bold())
        }
    }
}

#Preview {
    ExpenseTracker()
}
