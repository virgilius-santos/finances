import SwiftUI

struct WalletHomeBackgroundView<TopContent: View, BottomContent: View>: View {
    @ViewBuilder
    let topContent: () -> TopContent
    
    @ViewBuilder
    let bottomContent: () -> BottomContent
    
    var body: some View {
        VStack(spacing: 0) {
            
            topContent()
            
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    
                    VStack(spacing: 16) {
                        
                        bottomContent()
                    }
                }
                .padding(.top, 32)
                .padding([.horizontal, .bottom], 16)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .background {
                CustomCorner(corners: [.topLeft, .topRight], radius: 32)
                    .fill(.white)
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: -5)
            }
            .padding(.top, 20)
        }
        .background {
            Rectangle()
                .fill(.black.opacity(0.05))
                .ignoresSafeArea()
        }
    }
}
