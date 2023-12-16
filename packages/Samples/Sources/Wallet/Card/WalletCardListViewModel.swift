import Foundation

final class WalletCardListViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var expanded: Bool = false
    @Published var showDetailView = false
    @Published var selectedCard: Card?
    
    @Published var showDetailContent = false
    
    var cardToShow: Card? {
        guard let selectedCard, showDetailView else { return nil }
        return selectedCard
    }
    
    let store: WalletStore
    let screenSize: CGSize
    
    init(screenSize: CGSize, store: WalletStore) {
        self.screenSize = screenSize
        self.store = store
        cards = store.cards
    }
    
    func reversedIndex(for index: Int) -> (reversedIndex: CGFloat, displayingStackIndex: CGFloat, displayScale: CGFloat) {
        let reversedIndex = CGFloat((cards.count - 1) - index)
        let displayingStackIndex = min(reversedIndex, 2)
        let displayScale = (displayingStackIndex / CGFloat(cards.count)) * 0.15
        return (
            reversedIndex,
            expanded ? 0 : CGFloat(displayingStackIndex * -16),
            1 - (expanded ? 0 : displayScale)
        )
    }
    
    func isShowingCardSelected(_ index: Int) -> Bool {
        selectedCard == cards[index] && showDetailView
    }
}
