import SwiftUI

extension View {
    @ViewBuilder
    func defineCardsPosition() -> some View {
        self
        
        // Only used to fetch the frame bounds and it's position in the screen
        Rectangle()
            .fill(.clear)
            .frame(height: 256)
            .anchorPreference(key: WalletCardRectKey.self, value: .bounds, transform: { anchor in
                return ["CardRect": anchor]
            })
            .padding(.horizontal, 16)
    }
    
    func showCards(compress: Bool, allowsHitTesting: Bool, cards: @escaping () -> some View) -> some View {
        overlayPreferenceValue(WalletCardRectKey.self, { preferences in
            if let cardPreference = preferences["CardRect"] {
                // Geometry Reader is Used to extract cgrect from the anchor
                GeometryReader { proxy in
                    let cardRect = proxy[cardPreference]
                    cards()
                        .frame(width: cardRect.width, height: compress ? cardRect.height : nil)
                    // positon it using offset
                        .offset(x: cardRect.minX, y: cardRect.minY)
                        .allowsHitTesting(allowsHitTesting)
                }
            }
        })
    }
}

private struct WalletCardRectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = .init()
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
