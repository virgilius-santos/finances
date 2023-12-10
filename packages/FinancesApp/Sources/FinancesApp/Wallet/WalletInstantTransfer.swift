import SwiftUI

struct WalletInstantTransfer: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Instant Transfer")
                .font(.title3.bold())
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(1...10, id: \.self) { index in
                        WalletImage(
                            named: "pic\(index)",
                            contentMode: .fill,
                            size: .init(width: 50, height: 50)
                        )
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
