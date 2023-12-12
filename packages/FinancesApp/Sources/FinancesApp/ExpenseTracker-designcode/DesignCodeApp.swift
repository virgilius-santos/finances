import SwiftUI
import SwiftUIFontIcon
import Collections

public extension WindowGroup where Content == DesignCodeApp.MainView {
    static var designCodeApp: some Scene {
        #if os(macOS)
        WindowGroup(content: { DesignCodeAppView() })
            .windowsStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup(content: { DesignCodeApp.MainView() })
        #endif
    }
}

public enum DesignCodeApp {}

extension DesignCodeApp {
    public struct MainView: View {
        @StateObject private var viewModel = TransactionListViewModel()
        
        public var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Overview")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.text)
                        
                        RecentTransactionList(viewModel: viewModel)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(Color.background)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem {
                        Image(systemName: "bell.badge")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.icon, .primary)
                    }
                })
            }
            .tint(.primary)
        }
        
        public init() {}
    }
    
    typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
    
    final class TransactionListViewModel: ObservableObject {
        @Published var transactions = [Transaction]()
        
        init() {
            loadTransactions()
        }
        
        func loadTransactions() {
            transactions = DesignCodeApp.transactions
        }
        
        func groupTransactionsByMonth() -> TransactionGroup {
            TransactionGroup(grouping: transactions) { $0.month }
        }
    }
    
    struct TransactionListView: View {
        let transactions: TransactionGroup
        
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                    ForEach(Array(transactions), id: \.key) { section, transactions in
                        Section(
                            content: {
                                ForEach(transactions, id: \.id) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            },
                            header: {
                                Text(section)
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct RecentTransactionList: View {
        @ObservedObject var viewModel: TransactionListViewModel
        
        var body: some View {
            VStack {
                HStack {
                    Text("Recent Transactions")
                        .bold()
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: {
                            TransactionListView(transactions: viewModel.groupTransactionsByMonth())
                        },
                        label: {
                            HStack(spacing: 4) {
                                Text("See all")
                                Image(systemName: "chevron.right")
                            }
                            .foregroundStyle(Color.text)
                        }
                    )
                }
                .padding(.top)
                
                LazyVStack {
                    ForEach(viewModel.transactions.prefix(5), id: \.id) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
    
    struct TransactionRow: View {
        let transaction: Transaction
        
        var body: some View {
            HStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.icon.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay {
                        FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24 , color: Color.icon)
                    }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(transaction.merchant)
                        .font(.subheadline)
                        .bold()
                    
                    Text(transaction.category)
                        .font(.footnote)
                        .opacity(0.7)
                    
                    Text(transaction.date, format: .dateTime.year().month().day())
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                }
                
                Spacer()
                
                Text(transaction.signedAmount , format: .currency(code: "BRL"))
                    .font(.footnote)
                    .foregroundStyle(transaction.textColor)
                
            }
        }
    }
}

extension DesignCodeApp {
    static let transactions: [Transaction] = {
        var transactions = [Transaction]()
        for i in 0...34 {
            transactions.append( .init(
                date: {
                    var d = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                    d.month = Int.random(in: 1...12)
                    return Calendar.current.date(from: d) ?? .now
                }(),
                amount: Double.random(in: 0...20000),
                type: Bool.random() ? .debit : .credit)
            )
        }
        return transactions.sorted(by: { $1.date < $0.date })
    }()
    
    struct Transaction: Identifiable {
        let id: UUID = .init()
        var merchant = "Apple"
        var category = "Software"
        var date = Date()
        var amount = 2599.98
        var type = TransactionType.credit
        var categoryId: Int = Category.all.randomElement()?.id ?? 0
        
        var icon: FontAwesomeCode {
            if let category = Category.all.first(where: { $0.id == categoryId }) {
                return category.icon
            }
            
            return .question
        }
        
        var textColor: Color {
            switch type {
            case .debit:
                return .primary
            case .credit:
                return .text
            }
        }
        
        var signedAmount: Double {
            switch type {
            case .debit:
                return amount * -1
            case .credit:
                return amount
            }
        }
        
        var month: String {
            date.formatted(.dateTime.year().month(.wide))
        }
    }
    
    enum TransactionType {
        case debit, credit
    }
    
    struct Category: Identifiable {
        let id: Int
        let name: String
        let icon: FontAwesomeCode
        var mainCategoryId: Int?
        
        var subcategories: [Category]? {
            Category.subCategories.filter { $0.mainCategoryId == id }
        }
    }
}

extension DesignCodeApp.Category {
    static let autoAndTransport = Self(id: 1, name: "Auto & Transport", icon: .car_alt)
    static let billsAndUtilities = Self(id: 2, name: "Bills & Utilities", icon: .file_invoice_dollar)
    static let entertainment = Self(id: 3, name: "Entertainment", icon: .film)
    static let feesAndCharges = Self(id: 4, name: "Fees & Charges", icon: .hand_holding_usd)
    static let foodAndDining = Self(id: 5, name: "Food & Dining", icon: .hamburger)
    static let home = Self(id: 6, name: "Home", icon: .home)
    static let income = Self(id: 7, name: "Income", icon: .dollar_sign)
    static let shopping = Self(id: 8, name: "Shopping", icon: .shopping_cart)
    static let transfer = Self(id: 9, name: "Transfer", icon: .exchange_alt)
    
    static let publicTransportation = Self(id: 101, name: "Public Transportation", icon: .bus, mainCategoryId: 1)
    static let taxi = Self(id: 102, name: "Taxi", icon: .taxi, mainCategoryId: 1)
    static let mobilePhone = Self(id: 201, name: "Mobile Phone", icon: .mobile_alt, mainCategoryId: 2)
    static let moviesAndDVDs = Self(id: 301, name: "Movies & DVDs", icon: .film, mainCategoryId: 3)
    static let bankFee = Self(id: 401, name: "Bank Fee", icon: .hand_holding_usd, mainCategoryId: 4)
    static let financeCharge = Self(id: 402, name: "Finance Charge", icon: .hand_holding_usd, mainCategoryId: 4)
    static let groceries = Self(id: 501, name: "Groceries", icon: .shopping_basket, mainCategoryId: 5)
    static let restaurants = Self(id: 502, name: "Restaurants", icon: .utensils, mainCategoryId: 5)
    static let rent = Self(id: 601, name: "Rent", icon: .house_user, mainCategoryId: 6)
    static let homeSupplies = Self(id: 602, name: "Home Supplies", icon: .lightbulb, mainCategoryId: 6)
    static let paycheque = Self(id: 701, name: "Paycheque", icon: .dollar_sign, mainCategoryId: 7)
    static let software = Self(id: 801, name: "Software", icon: .icons, mainCategoryId: 8)
    static let creditCardPayment = Self(id: 901, name: "Credit Card Payment", icon: .exchange_alt, mainCategoryId: 9)
}

extension DesignCodeApp.Category {
    static let categories: [DesignCodeApp.Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
    ]
    
    static let subCategories: [DesignCodeApp.Category] = [
        .publicTransportation,
        .taxi,
        .mobilePhone,
        .moviesAndDVDs,
        .bankFee,
        .financeCharge,
        .groceries,
        .restaurants,
        .rent,
        .homeSupplies,
        .paycheque,
        .software,
        .creditCardPayment
    ]
    
    static let all: [DesignCodeApp.Category] = categories + subCategories
}
