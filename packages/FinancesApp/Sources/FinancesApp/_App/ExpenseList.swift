import FoundationUtils
import SwiftUI
import SwiftUIComponents

public struct ExpenseList: View {
    public var body: some View {
//        HomeView(viewModel: .init())
        Add.FormView(result: { _ in })
    }
    
    public init() {}
    
    enum Add {}
}

extension ExpenseList {
    struct HomeView: View {
        @StateObject var viewModel: ViewModel
        @State private var addExpense = false
        
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
//                    AddView(result: { viewModel.add(expense: $0) })
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
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ExpenseList.Add {
    struct FormView: View {
        static var description = "\(Self.self)"
                
        var result: (ExpenseList.Expense) -> Void
        @StateObject private var viewModel: AddViewModel = .init()
        
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
                        CustomSection(title: "Preview") {
                            ExpenseRow(
                                viewModel: viewModel.preview,
                                isSwipeEnabled: false
                            )
                        }
                        
                        CustomSection(title: "Title") {
                            TextField("Magic Keyboard", text: $viewModel.model.title)
                        }
              
                        CustomSection(title: "Title") {
                            HStack(spacing: 0) {
                                Picker("", selection: $viewModel.model.category) {
                                    Text("<Nothing>").tag(nil as Category?)
                                    ForEach(viewModel.allCategories) { category in
                                        Text(category.name)
                                            .tag(Optional(category))
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                
                                
                                Spacer(minLength: 0)
                                
                                HStack(spacing: 4) {
                                    switch viewModel.model.type {
                                    case .expense:
                                        IconButton(
                                            imageName: "plusminus.circle",
                                            action: { viewModel.model.type = .income }
                                        )
                                        .foregroundStyle(viewModel.model.type.style.color)
                                    case .income:
                                        IconButton(
                                            imageName: "plusminus.circle.fill",
                                            action: { viewModel.model.type = .expense }
                                        )
                                        .foregroundStyle(viewModel.model.type.style.color)
                                    }
                                    
                                    Text("\(viewModel.model.type.sign)R$")
                                    TextField("", value: $viewModel.model.amount, formatter: NumberFormatter.maxFractionDigits)
                                        .keyboardType(.decimalPad)
                                        .fixedSize()
                                }
                                .foregroundStyle(viewModel.model.type.style.color)
                                .hSpacing(.trailing)
                            }
                            .hSpacing()
                        }
                        
                        CustomSection(title: "Category") {
                            Picker("", selection: $viewModel.model.category) {
                                Text("<Nothing selected>").tag(nil as Category?)
                                ForEach(viewModel.allCategories) { category in
                                    Text(category.name)
                                        .tag(Optional(category))
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                        
                        CustomSection(title: "Card") {
                            Picker("", selection: $viewModel.model.category) {
                                Text("<Nothing selected>").tag(nil as Category?)
                                ForEach(viewModel.allCategories) { category in
                                    Text(category.name)
                                        .tag(Optional(category))
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                        
                        CustomSection(title: "Date") {
                            DatePicker("", selection: $viewModel.model.date, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                        }
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
                            .disabled(!viewModel.model.isCompleted)
                    }
                }
            }
        }
        
        init(result: @escaping (ExpenseList.Expense) -> Void) {
            self.result = result
        }
        
        func addExpense() {
//            guard let category = viewModel.category else {
//                return
//            }
//            result(.init(
//                type: .income,
//                date: viewModel.date,
//                model: .init(
//                    title: viewModel.title,
//                    category: category,
//                    amount: .init(value: viewModel.amount, style: .income)
//                )
//            )
//            )
            dismiss()
        }
    }
    
    final class AddViewModel: ObservableObject {
        @Published var model = Model()
        
        var preview: ExpenseRow.ViewModel {
            .init(
                title: model.title.isEmpty ? "Título" : model.title,
                category: model.category ?? .undefined,
                amount: Amount(
                    value: model.amount,
                    style: model.type.style
                )
            )
        }
        
        var allCategories: [ExpenseRow.Category] = [
            .init(
                name: "Mercado",
                image: "cart.fill",
                style: .market
            )
        ]
        
        
    }
    
    struct Model {
        var type = ExpenseList.ExpenseType.income
        var title: String = ""
        var amount: Double = .init()
        var date: Date = .init()
        var category: ExpenseRow.Category?
        
        var isCompleted: Bool {
            !(title.isEmpty || amount.isZero || category == nil)
        }
    }
    
    struct CheckBox<S: Equatable & RawRepresentable>: View where S.RawValue: Hashable & StringProtocol {
        var list: [S]
        @Binding var selected: S
        
        var body: some View {
            HStack(spacing: 12) {
                ForEach(list, id: \.rawValue) { category in
                    HStack(spacing: 4) {
                        ZStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundStyle(Color.appTint)
                            
                            if self.selected == category {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.appTint)
                            }
                        }
                        
                        Text(category.rawValue)
                            .font(.caption)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        self.selected = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .hSpacing(.leading)
            .background(.background, in: .rect(cornerRadius: 8))
        }
    }
    
    struct CustomSection<Content: View>: View {
        var title: String
        @ViewBuilder var content: Content
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                    .padding(.horizontal, 16)
                
                content
                    .padding(.horizontal, 16)
                    .background(.background, in: .rect(cornerRadius: 12))
            }
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
    typealias ExpenseCard = ExpenseRow
    typealias Category = ExpenseRow.Category
    
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
    
    enum ExpenseType: String, Equatable, CaseIterable {
        case income = "Income"
        case expense = "Expense"
        
        var sign: String {
            switch self {
            case .income:
                return ""
            case .expense:
                return "-"
            }
        }
        
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
