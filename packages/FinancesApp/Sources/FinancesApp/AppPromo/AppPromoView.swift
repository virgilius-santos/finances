import SwiftUI

public extension WindowGroup where Content == AppPromo {
    static var appPromo: some Scene {
        #if os(macOS)
        WindowGroup(content: { AppPromo() })
            .windowsStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup(content: { AppPromo() })
        #endif
    }
}

public struct AppPromo: View {
    @AppStorage("isFirstTime") private var isFirstTime = true
    @State private var activeTab = Tab.recents
    
    public var body: some View {
        TabView(selection: $activeTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.model.title)
                    .tag(tab)
                    .tabItem { tab.model.tabContent }
            }
        }
        .tint(Color.appTint)
        .sheet(isPresented: $isFirstTime, content: {
            AppPromoIntroScreen()
                .interactiveDismissDisabled()
        })
    }
    
    public init() {}
}

struct TabModel {
    let title: String
    let image: String
}

extension TabModel {
    static let recents = Self(
        title: "Recents", 
        image: "calendar"
    )
    static let search = Self(
        title: "Search", 
        image: "magnifyingglass"
    )
    static let charts = Self(
        title: "Charts",
        image: "chart.bar.xaxis"
    )
    static let settings = Self(
        title: "Settings", 
        image: "gearshape"
    )
    
    @ViewBuilder
    var tabContent: some View {
        Image(systemName: image)
        Text(title)
    }
}

enum Tab: CaseIterable {
    case recents
    case search
    case charts
    case settings
    
    var model: TabModel {
        let model: TabModel
        switch self {
        case .recents:
            model = .recents
        case .search:
            model = .search
        case .charts:
            model = .charts
        case .settings:
            model = .settings
        }
        return model
    }
}

struct AppPromoIntroScreen: View {
    @AppStorage("isFirstTime") var isFirstTime = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("What's New in the Expense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 64)
                .padding(.bottom, 36)
            
            VStack(alignment: .leading, spacing: 24) {
                PointView(
                    symbol: "dollarsign",
                    title: "Transactions",
                    subtitle: "Keep track of your earnings and expenses."
                )
                PointView(
                    symbol: "chart.bar.fill",
                    title: "Virtual Charts",
                    subtitle: "View your transactions using eye-catching graphic representations."
                )
                PointView(
                    symbol: "magnifyingglass",
                    title: "Advance Filters",
                    subtitle: "Find the expenses you want by advance search and filtering."
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Spacer(minLength: 12)
            
            Button(action: { isFirstTime = false }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding(.vertical, 16)
                    .background(Color.appTint, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
                
            })
        }
        .padding(16)
    }
}

struct PointView: View {
    let symbol: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(Color.appTint.gradient)
                .frame(width: 44)
            
            
            VStack(alignment: .leading, spacing: 24) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(Color.gray)
            }
            
            
        }
    }
}
