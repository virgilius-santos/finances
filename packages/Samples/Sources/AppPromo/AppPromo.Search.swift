import Combine
import SwiftUI

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
