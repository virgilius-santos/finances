import SwiftUI

extension View {
    func addCardBackground(visible: Binding<Bool>, backAction: @escaping () -> Void) -> some View {
        overlay(content: {
            WalletCardSelectedBackground(visible: visible, backAction: backAction)
        })
    }
}

struct WalletCardSelectedBackground: View {
    @Binding var visible: Bool
    let backAction: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .overlay(alignment: .top, content: {
                HStack {
                    IconButton.backButton(action: {
                        backAction()
                    })
                    
                    Spacer()
                    
                    Text("All Cards")
                        .font(.title.bold())
                }
                .padding(16)
            })
            .opacity(visible ? 1 : 0)
    }
}
