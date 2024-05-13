import FoundationUtils
import SwiftUI
import SwiftUIComponents

public struct AppPromo: View {
    @AppStorage("isFirstTime") private var isFirstTime = true
    @AppStorage("isAppLockEnabled") var isAppLockEnabled = false
    @AppStorage("lockWhenApppGoesBackground") var lockWhenApppGoesBackground = false
    
    @State private var activeTab = Tab.Item.recents
    
    public var body: some View {
        LockView(
            lockType: .both, lockPin: "1234", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenApppGoesBackground,
            content: {
                TabView(selection: $activeTab) {
                    ForEach(Tab.Item.allCases, id: \.self) { tab in
                        tab.view
                            .tag(tab)
                            .tabItem { tab.content }
                    }
                }
                .tint(Color.appTint)
                .sheet(isPresented: $isFirstTime, content: {
                    AppPromo.IntroScreen.Home()
                        .interactiveDismissDisabled()
                })
            },
            forgotPin: {}
        )
        .modelContainer(previewContainer)
    }
    
    public init() {}

    public enum Tab {}
    public enum IntroScreen{}
    public enum AddExpense {}
}
