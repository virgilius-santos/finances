import SwiftUI

struct AddExpenseView: View {
    static var description = "\(Self.self)"
    
    var result: (Expense) -> Void
    @StateObject private var viewModel: AddExpenseViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Title") {
                    TextField("Magic Keyboard", text: $viewModel.title)
                }
                
                Section("Amount Spent") {
                    HStack(spacing: 4) {
                        Text("R$")
                        TextField("0.0", value: $viewModel.amount, formatter: NumberFormatter.twoFractionDigits)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section("Date") {
                    DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                }
                
                HStack {
                    Text("Category")
                    
                    Spacer()
                    
                    Picker("", selection: $viewModel.category) {
                        Text("<Nothing selected>").tag(nil as Category?)
                        ForEach(viewModel.allCategories) { category in
                            Text(category.name)
                                .tag(Optional(category))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", action: addExpense)
                        .disabled(!viewModel.isCompleted)
                }
            }
        }
    }
    
    init(categories: [Category], result: @escaping (Expense) -> Void) {
        self.result = result
        _viewModel = .init(wrappedValue: AddExpenseViewModel(allCategories: categories))
    }
    
    func addExpense() {
        guard let category = viewModel.category else {
            return
        }
        result(.init(
            title: viewModel.title,
            amount: viewModel.amount,
            date: viewModel.date,
            category: category
        ))
        dismiss()
    }
}

#Preview {
    ExpenseTracker()
}
