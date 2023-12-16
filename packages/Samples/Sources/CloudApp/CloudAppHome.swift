import SwiftUI
import SwiftUIComponents

struct CloudAppHome: View {
    @State private var currentTab = "Home"
    @State private var showMenu = false
    
    var body: some View {
        AdaptableStack(
            showMenu: $showMenu,
            content: { CloudAppMainContentView(showMenu: $showMenu) },
            menuView: { CloudAppSideMenuView(currentTab: $currentTab) },
            sideView: { CloudAppSideView() }
        )
    }
}
