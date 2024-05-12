import SwiftUI
import SwiftData
import SwiftUIComponents

extension AppPromo {
    struct RecentsView: View {
        
        @Environment(\.modelContext) var modelContext
        
        @AppStorage("userName") var userName = ""
        
        @State private var startDate = Date.now.startOfMonth
        @State private var endDate = Date.now.endOfMonth
        @State private var selectedCategory = Category.expense
//        @Query private var transactions: [Transaction]
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
                                    
                                    FilterTransactions(startDate: startDate, endDate: endDate) { transactions in
                                        CardView(
                                            income: transactions.total(category: .income),
                                            expense: transactions.total(category: .expense)
                                        )
                                        
                                        CustomSegmentedControl()
                                            .padding(.bottom, 12)
                                        
                                        ForEach(transactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                            NavigationLink(
                                                value: transaction,
                                                label: { TransactionView(transaction: transaction) }
                                            )
                                        }
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
                    .navigationDestination(for: Transaction.self) { transaction in
                        NewExpenseView(editTransaction: transaction)
                    }
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
                    destination: { NewExpenseView() },
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
        func CustomSegmentedControl() -> some View {
            HStack(spacing: 0) {
                SegmentedControl(category: .income)
                SegmentedControl(category: .expense)
            }
            .background(.gray.opacity(0.16), in: .capsule)
            .padding(.top, 4)
        }
        
        @ViewBuilder
        func SegmentedControl(category: Category) -> some View {
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

extension Array where Element == AppPromo.Transaction {
    func total(category: AppPromo.Category) -> Double {
        self.filter({ $0.category == category.rawValue })
            .map(\.amount)
            .reduce(Double.zero, +)
    }
}
