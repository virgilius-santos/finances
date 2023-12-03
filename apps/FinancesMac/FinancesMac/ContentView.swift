import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            SheetsView(viewModel: SheetsView.ViewModel(modelContext: modelContext))
        }
    }
    
    init() {
    }
}

#if DEBUG
#Preview {
    ContentView()
        .configPreview()
}
#endif

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

import SwiftData

protocol AddStore {
    func addNewSheet()
}

