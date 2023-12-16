import SwiftUI

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
