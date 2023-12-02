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
        let store = StoreImpl(modelContext: modelContext)
        let coordinator = AppCoordinator(store: store)
        let displayObject = SheetDisplayObject()
        let presenter = SheetPresenter(store: store, display: displayObject.thread)
        self.init(presenter: presenter, coordinator: coordinator)
        displayObject.viewModel = self
    }
}

import SwiftData

protocol AddStore {
    func addNewSheet()
    func delete()
}

final class StoreImpl: GetSheetsStore, AddStore {
    var modelContext: ModelContext
    var completion: (SheetsResult) -> Void = { _ in }
    
    init(modelContext: ModelContext) {
        
        self.modelContext = modelContext
    }
    
    func getSheets(completion: @escaping (SheetsResult) -> Void) {
        self.completion = completion
        sendList()
    }
    
    func addNewSheet() {
        modelContext.insert(FinancesDB.init())
        try? modelContext.save()
        sendList()
    }
    
    func sendList() {
        let descriptor = FetchDescriptor<FinancesDB>()
        let list: [FinancesDB] = (try? modelContext.fetch(descriptor)) ?? []
        completion(.success(list.map({ _ in .init(id: .init() )})))
    }
    
    func delete() {
        let descriptor = FetchDescriptor<FinancesDB>()
        let list: [FinancesDB] = (try? modelContext.fetch(descriptor)) ?? []
        for item in list {
            modelContext.delete(item)
        }
        sendList()
    }
}

final class AppCoordinator: SheetCoordinator {
    let store: AddStore
    
    init(store: AddStore) {
        self.store = store
    }
    
    func addNewSheet() {
        store.addNewSheet()
    }
    
    func goTo(item: SheetsViewModel.Item) {
        store.delete()
    }
}
