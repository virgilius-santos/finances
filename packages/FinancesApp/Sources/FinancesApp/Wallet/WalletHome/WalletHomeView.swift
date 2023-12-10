import SwiftUI

struct WalletHomeView: View {
    @StateObject private var viewModel: WalletHomeViewModel
    
    var body: some View {
        WalletCardContainerView(viewModel: viewModel.cardListViewModel) { cardList in
            WalletHomeBackgroundView(
                topContent: {
                    WalletHeaderView(action: viewModel.menuAction)
                    
                    cardList()
                },
                bottomContent: {
                    
                    WalletInstantTransfer()
                    
                    WalletChartView(viewModel: viewModel.chartViewModel)
                }
            )
        }
    }
    
    init(screenSize: CGSize) {
        _viewModel = .init(wrappedValue: .init(screenSize: screenSize))
    }
}

final class WalletHomeViewModel: ObservableObject {
    let screenSize: CGSize
    let store: WalletStore = .init()
    
    @Published var overview: [Overview]
    
    lazy var cardListViewModel = WalletCardListViewModel(screenSize: screenSize, store: store)
    lazy var chartViewModel = WalletChartViewModel(overview: _overview)
    
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        overview = store.overview
    }
    
    func menuAction() {
        print("Menu Clicked")
    }
}
