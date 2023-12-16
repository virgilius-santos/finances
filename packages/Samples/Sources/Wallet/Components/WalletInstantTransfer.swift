import SwiftUI
import SwiftUIComponents

struct WalletInstantTransfer: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instant Transfer")
                .font(.title3.bold())
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { index in
                        Image.makePic(index)
                        .clipShape(Circle())
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, -16)
        }
    }
}
