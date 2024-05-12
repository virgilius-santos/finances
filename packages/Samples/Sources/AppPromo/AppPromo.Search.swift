import Combine
import SwiftUI
import SwiftData

extension AppPromo {
    struct SearchView: View {
        @State private var searchText = ""
        @State private var filterText = ""
        @State private var selectedCategory: Category?
        
        private let searchPublisher = PassthroughSubject<String, Never>()
        
        var body: some View {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12) {
                        FilterTransactions(category: selectedCategory, searchText: filterText) { transactions in
                            ForEach(transactions) { transaction in
                                NavigationLink(
                                    destination: { TransactionView(editTransaction: transaction) },
                                    label: { TransactionCardView(transaction: transaction, showCategory: true) }
                                )
                            }
                        }
                    }
                    .padding(15)
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
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        ToolbarContent()
                    }
                }
            }
        }
        
        @ViewBuilder
        func ToolbarContent() -> some View {
            Menu(
                content: {
                    Button(
                        action: { selectedCategory = nil },
                        label: {
                            HStack {
                                Text("Both")
                                
                                if selectedCategory == nil {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    )
                    
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        Button(
                            action: { selectedCategory = category },
                            label: {
                                HStack {
                                    Text(category.rawValue)
                                    
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        )
                    }
                },
                label: {
                    Image(systemName: "slider.vertical.3")
                })
        }
    }
}
