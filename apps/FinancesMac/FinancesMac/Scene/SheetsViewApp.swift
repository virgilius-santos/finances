import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB
import SwiftData

extension SheetsView {
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        self.init(viewModel: viewModel)
    }
}

extension SheetsView.ViewModel {
    convenience init(modelContext: ModelContext) {
        let store = AppStore(modelContext: modelContext)
        let coordinator = AppCoordinator()
        let displayObject = SheetDisplayObject()
        let presenter = SheetPresenter(store: store, display: displayObject.thread)
        self.init(presenter: presenter, coordinator: coordinator)
        displayObject.viewModel = self
    }
}
