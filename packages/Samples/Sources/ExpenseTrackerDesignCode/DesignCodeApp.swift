import SwiftUI
import SwiftUIComponents
import SwiftUIFontIcon
import Collections

public struct DesignCodeApp: View {
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
