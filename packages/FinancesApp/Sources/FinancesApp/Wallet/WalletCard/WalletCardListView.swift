import SwiftUI

struct WalletCardListView: View {
    let size: CGSize
    var animation: Namespace.ID
    @ObservedObject var viewModel: WalletCardListViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(0 ..< viewModel.cards.count, id: \.self) { index in
                    
                    let card = viewModel.cards[index]
                    let args = viewModel.reversedIndex(for: index)
                    
                    ZStack {
                        if viewModel.cardToShow == card {
                            Rectangle()
                                .foregroundStyle(Color.clear)
                                .frame(height: 200)
                        } else {
                            
                            WalletCard(card: card)
                            // Applying 3d rotation
                                .rotation3DEffect(
                                    .init(degrees: viewModel.expanded ? (viewModel.showDetailView ? 0 : -16) : 0),
                                    axis: (x: 1.0, y: 0.0, z: 0.0),
                                    anchor: .top
                                )
                            //  hero effect id
                                .matchedGeometryEffect(id: card.id, in: animation)
                                .offset(y: viewModel.showDetailView ? (size.height * 0.9) : 0)
                                .onTapGesture {
                                    if viewModel.expanded {
                                        // expanding selected card
                                        viewModel.selectedCard = card
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            viewModel.showDetailView = true
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                viewModel.showDetailContent = true
                                            }
                                        }
                                    } else {
                                        // expading cards
                                        withAnimation(.easeInOut(duration: 0.36)) {
                                            viewModel.expanded = true
                                        }
                                    }
                                }
                        }
                    }
                    // applying scaling
                    .scaleEffect(args.displayScale)
                    // dispalying first three cars on the stack
                    .offset(y: args.displayingStackIndex)
                    // Stackeing one on another
                    .offset(y: CGFloat(index) * -200)
                    .padding(.top, viewModel.expanded ? (index == 0 ? 0 : 80) : 0)
                }
            }
            // appling remaing height as padding
            .padding(.top, 56)
            // reducing size
            .padding(.bottom, CGFloat(viewModel.cards.count - 1) * -200)
        }
        .scrollDisabled(!viewModel.expanded)
    }
}
