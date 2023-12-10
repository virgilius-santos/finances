import SwiftUI

struct WalletCard: View {
    var card: Card
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(card.color.gradient)
                    .overlay(alignment: .top) {
                        VStack {
                            HStack {
                                Image.sim
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Text(card.balance)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(24)
                        .foregroundStyle(Color.black)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3.5)
                // Card details
                    .overlay {
                        HStack {
                            Text(card.name)
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 0)
                            
                            WalletPNG(
                                named: card.logo,
                                contentMode: .fit,
                                size: .init(width: 40, height: 40)
                            )
                        }
                        .foregroundStyle(Color.white)
                        .padding(16)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .frame(height: 200)
    }
}
