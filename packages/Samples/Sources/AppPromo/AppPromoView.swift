import FoundationUtils
import SwiftUI
import SwiftUIComponents

public extension WindowGroup where Content == AppPromo {
    static var appPromo: some Scene {
        #if os(macOS)
        WindowGroup(content: { AppPromo() })
            .windowsStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup(content: { AppPromo() })
        #endif
    }
}

public struct AppPromo: View {
    @AppStorage("isFirstTime") private var isFirstTime = true
    @AppStorage("isAppLockEnabled") var isAppLockEnabled = false
    @AppStorage("lockWhenApppGoesBackground") var lockWhenApppGoesBackground = false
    
    @State private var activeTab = Tab.Item.recents
    
    public var body: some View {
        LockView(
            lockType: .both, lockPin: "1234", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenApppGoesBackground,
            content: {
                TabView(selection: $activeTab) {
                    ForEach(Tab.Item.allCases, id: \.self) { tab in
                        tab.view
                            .tag(tab)
                            .tabItem { tab.content }
                    }
                }
                .tint(Color.appTint)
                .sheet(isPresented: $isFirstTime, content: {
                    AppPromo.IntroScreen.Home()
                        .interactiveDismissDisabled()
                })
            },
            forgotPin: {}
        )
        .modelContainer(for: [AppPromo.Transaction.self], inMemory: true, isAutosaveEnabled: true)
    }
    
    public init() {}
    
    @ViewBuilder
    func content(for tab: Tab.Item) -> some View {
        Image(systemName: tab.model.image)
        Text(tab.model.title)
    }
    
    public enum Tab {}
    public enum IntroScreen{}
    public enum Recents {}
    public enum Search {}
    public enum Chart {}
    public enum Settings {}
    public enum AddExpense {}
}

extension AppPromo.Recents {
    struct RecentsView: View {
        
        @Environment(\.modelContext) var modelContext
        
        @AppStorage("userName") var userName = ""
        
        @State private var startDate = Date.now.startOfMonth
        @State private var endDate = Date.now.endOfMonth
        @State private var selectedCategory = AppPromo.Category.expense
        @Query private var transactions: [AppPromo.Transaction]
        @State private var showFilterView = false
        
        @Namespace private var animation
        
        var dateFilterButton: String {
            "\(startDate.shortDate) to \(endDate.shortDate)"
        }
        
        var body: some View {
            GeometryReader {
                let size = $0.size
                
                NavigationStack {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                            Section(
                                content: {
                                    Button(action: { showFilterView = true }, label: {
                                        Text(dateFilterButton)
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    })
                                    .hSpacing(.leading)
                                    
                                    CardView(income: 200, expense: 200)
                                    
                                    CustomSegmentedControl()
                                        .padding(.bottom, 12)
                                    
                                    ForEach(transactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                        NavigationLink(
                                            destination: { AppPromo.AddExpense.NewExpenseView(editTransaction: transaction) },
                                            label: { TransactionCard(transaction: transaction) }
                                        )
                                    }
                                },
                                header: {
                                    HeaderView(size)
                                }
                            )
                        }
                        .padding(16)
                    }
                    .background(.gray.opacity(0.16))
                    .blur(radius: showFilterView ? 8 : 0)
                    .disabled(showFilterView)
                }
                .overlay {
                    if showFilterView {
                        DateFilterView(
                            startDate: startDate,
                            endDate: endDate,
                            onSubmit: {
                                startDate = $0
                                endDate = $1
                                showFilterView = false
                            },
                            onClose: {
                                showFilterView = false
                            }
                        )
                        .transition(.move(edge: .leading))
                    }
                }
                .animation(.snappy, value: showFilterView)
            }
        }
        
        @ViewBuilder
        func HeaderView(_ size: CGSize) -> some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("Welcome")
                        .font(.title.bold())
                    
                    if !userName.isEmpty {
                        Text(userName)
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                })
                .visualEffect { content, geometryProxy in
                    content
                        .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
                }
                
                Spacer(minLength: 0)
                
                NavigationLink(
                    destination: { AppPromo.AddExpense.NewExpenseView() },
                    label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.appTint.gradient, in: .circle)
                            .contentShape(.circle)
                    }
                )
            }
            .padding(.bottom, 8)
            .background {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    Divider()
                }
                .visualEffect { content, geometryProxy in
                    content
                        .opacity(headerBGOpacity(geometryProxy))
                }
                .padding(.horizontal, -16)
                .padding(.top, -(safeArea.top + 16))
            }
        }
        
        func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
            let minY = proxy.frame(in: .scrollView).minY + safeArea.top
            return minY > 0 ? 0 : (-minY / 16)
        }
        
        func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
            let minY = proxy.frame(in: .scrollView).minY
            let screenHeight = size.height
            
            let progress = minY / screenHeight
            let scale = (min(max(progress, 0), 1)) * 0.4
            
            return 1 + scale
        }
        
        @ViewBuilder
        func CardView(income: Double, expense: Double) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text("\((expense - income).currencyString)")
                            .font(.title.bold())
                        
                        Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                            .font(.title3)
                            .foregroundStyle(expense > income ? .red : .green)
                    }
                    .padding(.bottom, 24)
                    
                    HStack(spacing: 0) {
                        CategoryIndicator(image: "arrow.down", tint: .green, category: .income, value: income)
                        
                        Spacer(minLength: 12)
                        
                        CategoryIndicator(image: "arrow.up", tint: .red, category: .expense, value: expense)
                    }
                }
                .padding([.horizontal, .bottom], 24)
                .padding(.top, 16)
            }
        }
        
        func CategoryIndicator(image: String, tint: Color, category: AppPromo.Category, value: Double) -> some View {
            HStack(spacing: 12) {
                Image(systemName: image)
                    .font(.callout.bold())
                    .foregroundStyle(tint)
                    .frame(width: 36, height: 36)
                    .background {
                        Circle()
                            .fill(tint.opacity(0.24).gradient)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Text(value.shortCurrencyString)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
                
                
            }
        }
        
        @ViewBuilder
        func CustomSegmentedControl() -> some View {
            HStack(spacing: 0) {
                SegmentedControl(category: .income)
                SegmentedControl(category: .expense)
            }
            .background(.gray.opacity(0.16), in: .capsule)
            .padding(.top, 4)
        }
        
        @ViewBuilder
        func SegmentedControl(category: AppPromo.Category) -> some View {
            Text(category.rawValue)
                .hSpacing()
                .padding(.vertical, 12)
                .background {
                    if category == selectedCategory {
                        Capsule()
                            .fill(.background)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation {
                        selectedCategory = category
                    }
                }
        }
        
        @ViewBuilder
        func TransactionCard(transaction: AppPromo.Transaction) -> some View {
            CustomSwipeView(
                cornerRadius: 12,
                content: {
                    HStack(spacing: 12) {
                        Text("\(String(transaction.title.prefix(1)))")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(AppPromo.TintColor.get(color: transaction.tintColor).value.gradient, in: .circle)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.title)
                                .foregroundStyle(.primary)
                            
                            Text(transaction.remarks)
                                .font(.caption)
                                .foregroundStyle(.primary.secondary)
                            
                            Text(transaction.dateAdded.shortDate)
                                .font(.caption2)
                                .foregroundStyle(.gray)
                        }
                        .hSpacing(.leading)
                        
                        Text(transaction.amount.currencyString)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 12))
                },
                actions: {
                    SwipeAction(tint: .red, icon: "trash", action: {
                        modelContext.delete(transaction)
                    })
                }
            )
        }
        
        struct DateFilterView: View {
            @State var startDate: Date
            @State var endDate: Date
            
            var onSubmit: (Date, Date) -> Void
            var onClose: () -> Void
            
            var body: some View {
                VStack(spacing: 16) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                        .id(startDate)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                        .id(startDate)
                    
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            onClose()
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 4))
                        .tint(.red)
                        
                        Button("Filter") {
                            onSubmit(startDate, endDate)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 4))
                        .tint(.appTint)
                    }
                    .padding(.top, 12)
                }
                .padding(16)
                .background(.bar, in: .rect(cornerRadius: 12))
                .padding(.horizontal, 32)
            }
        }
    }
}

extension AppPromo.AddExpense {
    struct NewExpenseView: View {
        @Environment(\.dismiss) var dismiss
        @Environment(\.modelContext) var modelContext
        
        var editTransaction: AppPromo.Transaction?
        
        @State private var title = ""
        @State private var remarks = ""
        @State private var amount = Double.zero
        @State private var dateAdded = Date.now
        @State private var category = AppPromo.Category.expense
        @State private var tintColor = AppPromo.TintColor.tints.randomElement()!
        
        var body: some View {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    Text("Preview")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    AppPromo.Recents.RecentsView().TransactionCard(transaction: .init(
                        title: title.isEmpty ? "Title" : title,
                        remarks: remarks.isEmpty ? "Remarks" : remarks,
                        amount: amount,
                        dateAdded: dateAdded,
                        category: category,
                        tintColor: tintColor
                    ))
                    
                    CustomSection(title: "Title", hint: "Margic Keyboard", text: $title)
                    
                    CustomSection(title: "Remarks", hint: "Apple Products!", text: $remarks)
                    
                    VStack(spacing: 12) {
                        Text("Amount & Category")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        HStack(spacing: 16) {
                            TextField("0.0", value: $amount, formatter: NumberFormatter.twoFractionDigits)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 12))
                                .frame(maxWidth: 130)
                                .keyboardType(.decimalPad)
                            
                            CategoryCheckBox(category: $category)
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Text("Date")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 12))
                    }
                }
                .padding(16)
            }
            .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
            .background(tintColor.value.opacity(0.16))
            .toolbar(content: {
                ToolbarItem {
                    Button("Save", action: save)
                }
            })
            .onAppear(perform: {
                if let editTransaction {
                    title = editTransaction.title
                    remarks = editTransaction.remarks
                    amount = editTransaction.amount
                    dateAdded = editTransaction.dateAdded
                    category = .init(rawValue: editTransaction.category) ?? .expense
                    tintColor = AppPromo.TintColor.get(color: editTransaction.tintColor)
                }
            })
        }
        
        func save() {
            if let editTransaction {
                editTransaction.title = title
                editTransaction.remarks = remarks
                editTransaction.amount = amount
                editTransaction.dateAdded = dateAdded
                editTransaction.category = category.rawValue
                editTransaction.tintColor = tintColor.color
            } else {
                let transaction = AppPromo.Transaction(
                    title: title,
                    remarks: remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tintColor
                )
                modelContext.insert(transaction)
            }
            dismiss()
        }
    }
    
    struct CustomSection: View {
        var title: String
        var hint: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                TextField(hint, text: $text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 12))
            }
        }
    }
    
    struct CategoryCheckBox: View {
        @Binding var category: AppPromo.Category
        
        var body: some View {
            HStack(spacing: 12) {
                ForEach(AppPromo.Category.allCases, id: \.rawValue) { category in
                    HStack(spacing: 4) {
                        ZStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundStyle(Color.appTint)
                            
                            if self.category == category {
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
                        self.category = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .hSpacing(.leading)
            .background(.background, in: .rect(cornerRadius: 8))
        }
    }
}

import Combine

extension AppPromo.Search {
    struct SearchView: View {
        @State private var searchText = ""
        @State private var filterText = ""
        
        private let searchPublisher = PassthroughSubject<String, Never>()
        
        var body: some View {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        
                    }
                }
                .overlay(content: {
                    ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                        .opacity(filterText.isEmpty ? 1 : 0)
                })
                .onChange(of: searchText, { oldValue, newValue in
                    searchPublisher.send(newValue)
                })
                .onReceive(searchPublisher.debounce(for: .seconds(0.4), scheduler: DispatchQueue.main), perform: { text in
                    filterText = text
                })
                .searchable(text: $searchText)
                .navigationTitle("Search")
                .background(.gray.opacity(0.15))
            }
        }
    }
}

extension AppPromo.Chart {
    struct ChartView: View {
        var body: some View {
            Text("Chart")
        }
    }
}

extension AppPromo.Settings {
    struct SettingsView: View {
        @AppStorage("userName") var userName = ""
        @AppStorage("isAppLockEnabled") var isAppLockEnabled = false
        @AppStorage("lockWhenApppGoesBackground") var lockWhenApppGoesBackground = false
        
        var body: some View {
            NavigationStack {
                List {
                    Section("User Name") {
                        TextField("iJustine", text: $userName)
                    }
                    
                    Section("App Lock") {
                        Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                        
                        if isAppLockEnabled {
                            Toggle("Lock When App Goes Background", isOn: $lockWhenApppGoesBackground)
                        }
                    }
                }
            }
        }
    }
}

// MARK: IntroScreen

extension AppPromo.IntroScreen {
    struct Home: View {
        @AppStorage("isFirstTime") var isFirstTime = true
        
        var body: some View {
            VStack(spacing: 16) {
                Text("What's New in the Expense Tracker")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 64)
                    .padding(.bottom, 36)
                
                VStack(alignment: .leading, spacing: 24) {
                    PointView(
                        symbol: "dollarsign",
                        title: "Transactions",
                        subtitle: "Keep track of your earnings and expenses."
                    )
                    PointView(
                        symbol: "chart.bar.fill",
                        title: "Virtual Charts",
                        subtitle: "View your transactions using eye-catching graphic representations."
                    )
                    PointView(
                        symbol: "magnifyingglass",
                        title: "Advance Filters",
                        subtitle: "Find the expenses you want by advance search and filtering."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                Spacer(minLength: 12)
                
                Button(action: { isFirstTime = false }, label: {
                    Text("Continue")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .padding(.vertical, 16)
                        .background(Color.appTint, in: .rect(cornerRadius: 12))
                        .contentShape(.rect)
                    
                })
            }
            .padding(16)
        }
    }
    
    struct PointView: View {
        let symbol: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: symbol)
                    .font(.largeTitle)
                    .foregroundStyle(Color.appTint.gradient)
                    .frame(width: 44)
                
                
                VStack(alignment: .leading, spacing: 24) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .foregroundStyle(Color.gray)
                }
                
                
            }
        }
    }
}

// MARK: Tab

extension AppPromo.Tab {
    enum Item: CaseIterable {
        case recents
        case search
        case charts
        case settings
    }
    
    struct Model {
        let title: String
        let image: String
    }
}

// MARK: Tab Models

extension AppPromo.Tab.Model {
    static let recents = Self(
        title: "Recents",
        image: "calendar"
    )
    static let search = Self(
        title: "Search",
        image: "magnifyingglass"
    )
    static let charts = Self(
        title: "Charts",
        image: "chart.bar.xaxis"
    )
    static let settings = Self(
        title: "Settings",
        image: "gearshape"
    )
}

extension AppPromo.Tab.Item {
    var model: AppPromo.Tab.Model {
        let model: AppPromo.Tab.Model
        switch self {
        case .recents:
            model = .recents
        case .search:
            model = .search
        case .charts:
            model = .charts
        case .settings:
            model = .settings
        }
        return model
    }
    
    @ViewBuilder
    var content: some View {
        Image(systemName: model.image)
        Text(model.title)
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .recents:
            AppPromo.Recents.RecentsView()
        case .search:
            AppPromo.Search.SearchView()
        case .charts:
            AppPromo.Chart.ChartView()
        case .settings:
            AppPromo.Settings.SettingsView()
        }
    }
}

// MARK: General Models

import SwiftData

extension AppPromo {
    
    enum Category: String, CaseIterable {
        case income = "Income"
        case expense = "Expense"
    }
    
    struct TintColor: Identifiable {
        let id = UUID()
        var color: String
        var value: Color
        
        init(color: String, value: Color) {
            self.color = color
            self.value = value
        }
        
        static func get(color: String) -> Self {
            tints.first(where: { $0.color == color }) ?? tints[0]
        }
        
        static var tints: [Self] = [
            .init(color: "Red", value: .red),
            .init(color: "Blue", value: .blue),
            .init(color: "Pink", value: .pink),
            .init(color: "Purple", value: .purple),
            .init(color: "Brown", value: .brown),
            .init(color: "Orange", value: .orange)
        ]
    }
    
    @Model
    class Transaction {
        var title: String
        var remarks: String
        var amount: Double
        var dateAdded: Date
        var category: String
        var tintColor: String
        
        init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
            self.title = title
            self.remarks = remarks
            self.amount = amount
            self.dateAdded = dateAdded
            self.category = category.rawValue
            self.tintColor = tintColor.color
        }
    }
}

//extension AppPromo.Transaction {
//    static let sample: [Self] = {
//        var transactions = [AppPromo.Transaction]()
//        for i in 0...12 {
//            transactions.append( .init(
//                title: "Magic",
//                remarks: "Apple",
//                amount: Double.random(in: 0...2000),
//                dateAdded: {
//                    var d = Calendar.current.dateComponents([.year, .month, .day], from: .now)
//                    d.month = Int.random(in: 1...12)
//                    return Calendar.current.date(from: d) ?? .now
//                }(),
//                category: AppPromo.Category.allCases.randomElement() ?? .income,
//                tintColor: AppPromo.TintColor.tints.randomElement() ?? AppPromo.TintColor.tints[0]
//            )
//            )
//        }
//        return transactions.sorted(by: { $1.dateAdded < $0.dateAdded })
//    }()
//}
