import SwiftUI

struct WalletCardDetailView: View {
    let size: CGSize
    let card: Card
    var animation: Namespace.ID
    @ObservedObject var viewModel: WalletCardListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Nav bar
            HStack {
                IconButton.backButton(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.showDetailContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.showDetailView = false
                        }
                    }
                })
                
                Spacer()
                
                Text("Transactions")
                    .font(.title2.bold())
            }
            .foregroundStyle(Color.black)
            .padding(16)
            .opacity(viewModel.showDetailContent ? 1 : 0)
            
            // Card view
            WalletCard(card: card)
                .rotation3DEffect(
                    .init(degrees: viewModel.showDetailContent ? 0 : -16),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .top
                )
                .matchedGeometryEffect(id: card.id, in: animation)
                .padding([.horizontal, .top], 16)
                .zIndex(1000)
            
            // Sample Expenses view
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    ForEach(viewModel.store.expenses) { expense in
                        HStack(spacing: 12) {
                            Image(systemName: "cart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.title)
                                    .fontWeight(.bold)
                                
                                Text(expense.category.name)
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer(minLength: 0)
                            
                            Text(expense.amount, format: .currency(code: "BRL"))
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                    }
                }
                .padding(.top, 24)
                .padding([.horizontal, .bottom], 16)
            }
            .scrollIndicators(.hidden)
            .background {
                CustomCorner(corners: [.topLeft, .topRight], radius: 32)
                    .fill(Color.white)
                    .padding(.top, -120)
                    .ignoresSafeArea()
            }
            .offset(y: !viewModel.showDetailContent ? (size.height * 0.7) : 0)
            .opacity(viewModel.showDetailContent ? 1 : 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(Color.init("bg", bundle: Bundle.module))
                .ignoresSafeArea()
                .opacity(viewModel.showDetailContent ? 1 : 0)
        }
        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
    }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
