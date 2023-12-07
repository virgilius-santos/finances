import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB
import SwiftData

extension SheetsView {
    init(modelContext: ModelContext, coordinator: AppCoordinator) {
        let viewModel = ViewModel(modelContext: modelContext, coordinator: coordinator)
        self.init(viewModel: viewModel)
    }
}

extension SheetsView.ViewModel {
    convenience init(modelContext: ModelContext, coordinator: AppCoordinator) {
        let displayObject = SheetsDisplayObject()
        let store = AppStore(modelContext: modelContext)
        let presenter = SheetsPresenter(store: store, display: displayObject.thread)
        self.init(presenter: presenter, coordinator: coordinator)
        displayObject.viewModel = self
    }
}
