import SwiftUI

struct WalletCardContainerView<V: View>: View {
    typealias CardPositionProvider = () -> AnyView
        
    @ObservedObject var viewModel: WalletCardListViewModel
    var cardPositionProvider: (@escaping CardPositionProvider) -> V
    
    @Namespace private var animation
    
    var body: some View {
        cardPositionProvider {
            AnyView(EmptyView().defineCardsPosition())
        }
        .addCardBackground(visible: $viewModel.expanded, backAction: {
            withAnimation(.easeInOut(duration: 0.36)) {
                viewModel.expanded = false
            }
        })
        .overlay(content: {
            if let card = viewModel.cardToShow {
                WalletCardDetailView(size: viewModel.screenSize, card: card, animation: animation, viewModel: viewModel)
            }
        })
        .showCards(
            compress: !viewModel.expanded,
            allowsHitTesting: !viewModel.showDetailView
        ) {
            WalletCardListView(size: viewModel.screenSize, animation: animation, viewModel: viewModel)
        }
    }
}
