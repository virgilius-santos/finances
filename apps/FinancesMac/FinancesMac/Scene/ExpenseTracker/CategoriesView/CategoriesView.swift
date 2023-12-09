import SwiftUI
import FinancesApp

struct CategoriesView: View {
    static var description = "\(Self.self)"
    
    @StateObject private var viewModel: CategoriesViewModel
    
    @State private var addCategory = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.categories) { category in
                    DisclosureGroup {
                        if !category.expenses.isEmpty {
                            ForEach(category.expenses) {
                                ExpensesCard(expense: $0)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Expenses", systemImage: "tray.fill")
                            }
                        }
                    } label: {
                        Text(category.name)
                    }
                }
            }
            .navigationTitle("Categories")
            .overlay {
                if viewModel.categories.isEmpty {
                    ContentUnavailableView {
                        Label("No Categories", systemImage: "tray.fill")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconButton.addButton(action: { addCategory.toggle() })
                }
            }
            .sheet(isPresented: $addCategory, content: {
                NavigationStack {
                    List {
                        Section("Title") {
                            TextField("General", text: $viewModel.categoryName)
                        }
                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Add") {
                                addCategory = false
                                viewModel.addCategory()
                            }
                            .disabled(!viewModel.isCompleted)
                        }
                    }
                }
                .presentationDetents([.medium])
                .presentationCornerRadius(20)
            })
            .onAppear {
                viewModel.load()
            }
        }
    }
    
    init(store: ExpenseStore) {
        _viewModel = .init(wrappedValue: CategoriesViewModel(store: store))
    }
}

#Preview {
    ExpenseTracker()
}

final class CategoriesViewModel: ObservableObject {
    struct CategoryViewModel: Hashable, Identifiable {
        var id: String { name }
        var name: String
        var expenses: [Expense]
    }
    
    @Published var categories: [CategoryViewModel] = []
    @Published var categoryName: String = ""
    
    let store: ExpenseStore
    
    var isCompleted: Bool {
        !categoryName.isEmpty
    }
    
    init(store: ExpenseStore) {
        self.store = store
    }
    
    func load() {
        var categories: [Category: [Expense]] = [:]
        store.categories.forEach({ category in categories[category] = [] })
        store.allExpenses.forEach({ expense in
            categories[expense.category] = (categories[expense.category] ?? []) + [expense]
        })
        self.categories = categories
            .reduce([], { categories, dict in
                categories + [.init(name: dict.key.name, expenses: dict.value)]
            })
            .sorted(by: { $0.name < $1.name })
    }
    
    func addCategory() {
        store.categories.append(.init(name: categoryName))
        categoryName = ""
        load()
    }
}
