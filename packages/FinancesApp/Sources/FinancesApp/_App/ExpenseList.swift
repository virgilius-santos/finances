import SwiftUI

enum ExpenseList {}

extension ExpenseList {
    struct HomeView: View {
        @StateObject var viewModel: ViewModel
        @State private var addExpense = true
        
        var body: some View {
            NavigationStack {
                CustomSegmentedControl(selectedType: $viewModel.selectedType)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 16)
                
                ListView(
                    groupedExpenses: $viewModel.groupedExpenses,
                    selectAction: { expense, group in
                        withAnimation {
                            viewModel.select(expense: expense, in: group)
                        }
                    },
                    deleteAction: { expense, group in
                        withAnimation {
                            viewModel.remove(expense: expense, in: group)
                        }
                    }
                )
                .navigationTitle(viewModel.title)
                .overlay {
                    if case let .empty(viewModel) = viewModel.state {
                        ContentUnavailableView {
                            Label(viewModel.title, systemImage: viewModel.image)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        IconButton.addButton(action: { addExpense.toggle() })
                    }
                }
                .onChange(of: viewModel.state) { oldValue, newValue in
                    viewModel.createGroupedExpenses(newValue)
                }
                .onChange(of: viewModel.selectedType) { oldValue, newValue in
                    viewModel.createGroupedExpenses(newValue)
                }
                .sheet(isPresented: $addExpense, content: {
                    AddView(result: { viewModel.add(expense: $0) })
                })
                .onAppear {
                    viewModel.load()
                }
            }
        }
    }
    
    struct ListView: View {
        @Binding var groupedExpenses: [GroupedExpenses]
        var selectAction: (Expense, GroupedExpenses) -> Void
        var deleteAction: (Expense, GroupedExpenses) -> Void
        
        var body: some View {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(groupedExpenses) { group in
                        Section(group.title) {
                            ForEach(group.expenses) { expense in
                                ExpenseCard(
                                    viewModel: expense.model,
                                    tapAction: { selectAction(expense, group) },
                                    deleteAction: { deleteAction(expense, group) }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ExpenseList {
    struct AddView: View {
        static var description = "\(Self.self)"
        
        var result: (Expense) -> Void
        @StateObject private var viewModel: AddViewModel = .init()
        
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                Form {
                    Picker("", selection: $viewModel.type) {
                        Text(ExpenseType.income.rawValue)
                            .tag(ExpenseType.income)
                        
                        Text(ExpenseType.expense.rawValue)
                            .tag(ExpenseType.expense)
                        
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    
                    Section("Title") {
                        TextField("Magic Keyboard", text: $viewModel.title)
                    }
                    
                    Section("Amount Spent") {
                        HStack(spacing: 4) {
                            Text("R$")
                            TextField("0.0", value: $viewModel.amount, formatter: NumberFormatter.twoFractionDigits)
                                .keyboardType(.numberPad)
                                
                        }
                        .foregroundStyle(viewModel.type.style.color)
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
                    
                    Section("Date") {
                        DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
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
        
        init(result: @escaping (Expense) -> Void) {
            self.result = result
        }
        
        func addExpense() {
            guard let category = viewModel.category else {
                return
            }
            result(.init(
                type: .income,
                date: viewModel.date,
                model: .init(
                    title: viewModel.title,
                    category: category,
                    amount: .init(value: viewModel.amount, style: .income)
                )
            )
            )
            dismiss()
        }
    }
    
    final class AddViewModel: ObservableObject {
        @Published var type = ExpenseType.income
        @Published var title = ""
        @Published var date = Date()
        @Published var amount = CGFloat.zero
        @Published var category: Category?
        
        var allCategories: [Category] = [
            .init(
                name: "Mercado",
                image: "cart.fill",
                style: .market
            )
        ]
        
        var isCompleted: Bool {
            !(title.isEmpty || amount.isZero || category == nil)
        }
    }
}

// MARK: Segmented

extension ExpenseList {
    struct CustomSegmentedControl: View {
        @Binding var selectedType: ExpenseType
        @Namespace private var animation
        
        var body: some View {
            HStack(spacing: 0) {
                SegmentedControl(
                    selectedType: $selectedType,
                    expenseType: .income,
                    animation: animation
                )
                
                SegmentedControl(
                    selectedType: $selectedType,
                    expenseType: .expense,
                    animation: animation
                )
            }
            .background(.gray.opacity(0.16), in: .capsule)
            .padding(.top, 4)
        }
    }
    
    struct SegmentedControl: View {
        @Binding var selectedType: ExpenseType
        let expenseType: ExpenseType
        let animation: Namespace.ID
        
        var body: some View {
            Text(expenseType.rawValue)
                .hSpacing()
                .padding(.vertical, 12)
                .background {
                    if expenseType == selectedType {
                        Capsule()
                            .fill(.background)
                            .padding(2)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation {
                        selectedType = expenseType
                    }
                }
        }
    }
}

// MARK: Models

extension ExpenseList {
    typealias ExpenseCard = ExpenseRow.RowView
    typealias Category = ExpenseRow.ViewModel.Category
    
    enum HomeState: Equatable {
        case empty(EmptyContent)
        case list([Expense], ExpenseType)
    }
    
    final class ViewModel: ObservableObject {
        @Published var state: HomeState = .empty(.default)
        
        @Published var groupedExpenses: [GroupedExpenses] = []
        @Published var title = "Expenses"
        @Published var selectedType: ExpenseType = .income
                
        func load() {
            state = .empty(.default)
            state = .list([
                .init(type: .income, date: .now, model: .init(
                    title: "Versus Card",
                    category: .init(
                        name: "Mercado",
                        image: "cart.fill",
                        style: .market
                    ),
                    amount: .init(value: 234.88, style: .income)
                )),
                .init(type: .expense, date: .addMonth(from: -1), model: .init(
                    title: "Versus Card",
                    category: .init(
                        name: "Mercado",
                        image: "cart.fill",
                        style: .market
                    ),
                    amount: .init(value: 29.88, style: .expense)
                ))
            ], selectedType)
        }
        
        func add(expense: Expense) {
            switch state {
            case .empty:
                state = .list([expense], selectedType)
            case let .list(allExpenses, type):
                state = .list(allExpenses + [expense], type)
            }
        }
        
        func remove(expense: Expense, in group: GroupedExpenses) {
            
        }
        
        func select(expense: Expense, in group: GroupedExpenses) {
            
        }
        
        func createGroupedExpenses(_ type: ExpenseType) {
            switch state {
            case .empty:
                break
            case let .list(allExpenses, _) where allExpenses.isEmpty:
                state = .empty(.default)
            case let .list(allExpenses, _):
                state = .list(allExpenses, type)
            }
        }
        
        func createGroupedExpenses(_ state: HomeState) {
            switch state {
            case .empty:
                break
            case let .list(expenses, selectedType):
                Task.detached(priority: .high) {
                    let filtered = expenses.filter({ $0.type == selectedType })
                    let groupedDict = Dictionary(grouping: filtered) { expense in
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
        }
        
        @MainActor
        func update(groupedExpenses: [GroupedExpenses]) {
            self.groupedExpenses = groupedExpenses
        }
    }
    
    struct EmptyContent: Equatable {
        static let `default` = Self.init(title: "No Expenses", image: "tray.fill")
        
        let title: String
        let image: String
    }
    
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
    
    struct Expense: Equatable, Identifiable {
        typealias Model = ExpenseRow.ViewModel
        var id: UUID { model.id }
        let type: ExpenseType
        let date: Date
        let model: Model
    }
    
    enum ExpenseType: String, Equatable {
        case income = "Income"
        case expense = "Expense"
        
        var style: CurrencyStyle {
            switch self {
            case .income:
                return .income
            case .expense:
                return .expense
            }
        }
    }
}

#Preview("ExpenseRow.Row") {
    ExpenseList.HomeView.init(viewModel: .init())
}
