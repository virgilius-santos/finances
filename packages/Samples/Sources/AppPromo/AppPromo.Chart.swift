import SwiftUI
import Charts
import SwiftData
import SwiftUIComponents
import FoundationUtils

extension AppPromo {
    struct ChartView: View {
        
        @Query(animation: .snappy) private var transactions: [Transaction]
        @State private var chartGroups = [ChartGroup]()
        var body: some View {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        ChartView()
                            .frame(height: 200)
                            .padding(12)
                            .padding(.top, 12)
                            .background(.background, in: .rect(cornerRadius: 12))
                        
                        ForEach(chartGroups) { group in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(group.date.shortDate)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .hSpacing(.leading)
                                
                                NavigationLink(
                                    destination: { ListOfExpenses(month: group.date) },
                                    label: { CardView(income: group.totalIncome, expense: group.totalExpense) }
                                )
                            }
                        }
                    }
                    .padding(16)
                }
                .navigationTitle("Graphs")
                .background(.gray.opacity(0.16))
                .onAppear {
                    createChartGroup()
                }
            }
        }
        
        @ViewBuilder
        func ChartView() -> some View {
            Chart {
                ForEach(chartGroups) { group in
                    ForEach(group.categories) { chart in
                        BarMark(
                            x: .value("Month", group.date.shortDate),
                            y: .value(chart.category.rawValue, chart.totalValue),
                            width: 20
                        )
                        .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                        .foregroundStyle(by: .value("Category", chart.category.rawValue))
                    }
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 4)
            .chartLegend(position: .bottom, alignment: .trailing)
            .chartYAxis(content: {
                AxisMarks(position: .leading) { value in
                    let doubleValue = value.as(Double.self) ?? 0
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        Text(axisLAbel(doubleValue))
                    }
                }
            })
            .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
        }
        
        func createChartGroup() {
            Task.detached(priority: .high) {
                let calendar = Calendar.current
                let groupedByDate = Dictionary(grouping: transactions, by: { transaction in
                    calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                })
                let sortedGroups = groupedByDate.sorted {
                    let date1 = calendar.date(from: $0.key) ?? .init()
                    let date2 = calendar.date(from: $1.key) ?? .init()
                    return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
                }
                
                let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                    let date = calendar.date(from: dict.key) ?? .init()
                    let income = dict.value.filter({ $0.category == Category.income.rawValue })
                    let expense = dict.value.filter({ $0.category == Category.expense.rawValue })
                    let incomeTotalValue = income.total(category: .income)
                    let expenseTotalValue = expense.total(category: .expense)
                    return .init(
                        date: date,
                        categories: [
                            ChartCategory(totalValue: incomeTotalValue, category: .income),
                            ChartCategory(totalValue: expenseTotalValue, category: .expense)
                        ],
                        totalIncome: incomeTotalValue,
                        totalExpense: expenseTotalValue
                    )
                }
                
                await MainActor.run {
                    self.chartGroups = chartGroups
                }
            }
        }
        
        func axisLAbel(_ value: Double) -> String {
            let intValue = Int(value)
            switch intValue {
            case let value where abs(value) < 1000:
                return "\(intValue)"
            default:
                let kValue = intValue / 1000
                return "\(kValue)K"
            }
        }
    }
    
    struct ListOfExpenses: View {
        var month: Date
        var body: some View {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    TransactionSection(title: "Income", category: .income)
                    
                    TransactionSection(title: "Expense", category: .expense)
                }
                .padding(16)
            }
            .background(.gray.opacity(0.16))
            .navigationTitle(month.shortDate)
        }
        
        @ViewBuilder
        func TransactionSection(title: String, category: Category) -> some View {
            Section(
                content: {
                    FilterTransactions(startDate: month.startOfMonth, endDate: month.endOfMonth, category: category) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink(
                                destination: { NewExpenseView(editTransaction: transaction) },
                                label: { TransactionView(transaction: transaction) }
                            )
                            .buttonStyle(.plain)
                        }
                    }
                },
                header: {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
            )
        }
    }
    
    struct ChartGroup: Identifiable {
        let id = UUID()
        var date: Date
        var categories: [ChartCategory]
        var totalIncome: Double
        var totalExpense: Double
    }
    
    struct ChartCategory: Identifiable {
        let id = UUID()
        var totalValue: Double
        var category: Category
    }
}
