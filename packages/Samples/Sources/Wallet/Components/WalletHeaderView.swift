import SwiftUI
import SwiftUIComponents

struct WalletHeaderView: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            IconButton.menuButton(action: action)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Your Balance")
                    .font(.caption)
                    .foregroundColor(.black)
                
                Text("$2345,00")
                    .font(.title2.bold())
            }
        }
        .padding([.horizontal, .top], 16)
    }
}
