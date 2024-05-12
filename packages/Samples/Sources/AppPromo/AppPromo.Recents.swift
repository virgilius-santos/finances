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
                                        CardView(income: 200, expense: 200)
                                        
                                        CustomSegmentedControl()
                                            .padding(.bottom, 12)
                                        
                                        ForEach(transactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                            NavigationLink(
                                                destination: { NewExpenseView(editTransaction: transaction) },
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
        
        func CategoryIndicator(image: String, tint: Color, category: Category, value: Double) -> some View {
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
