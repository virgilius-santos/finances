import SwiftUI

// MARK: Tab

extension AppPromo.Tab {
    enum Item: CaseIterable {
        case recents
        case search
        case charts
        case settings
    }
    
    struct Model {
        let title: String
        let image: String
    }
}

// MARK: Tab Models

extension AppPromo.Tab.Model {
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
}

extension AppPromo.Tab.Item {
    var model: AppPromo.Tab.Model {
        let model: AppPromo.Tab.Model
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
    
    @ViewBuilder
    var content: some View {
        Image(systemName: model.image)
        Text(model.title)
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .recents:
            AppPromo.RecentsView()
        case .search:
            AppPromo.SearchView()
        case .charts:
            AppPromo.ChartView()
        case .settings:
            AppPromo.SettingsView()
        }
    }
}
