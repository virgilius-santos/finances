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

final class StoreImpl: SheetStore, AddStore {
    var modelContext: ModelContext
    var completion: (GetSheetsResult) -> Void = { _ in }
    
    init(modelContext: ModelContext) {
        
        self.modelContext = modelContext
    }
    
    func getSheets(completion: @escaping (GetSheetsResult) -> Void) {
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
        completion(.success(list.map(\.dto)))
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
    func addNewSheet(completion: (NewSheetResult) -> Void) {
        store.addNewSheet()
        completion(true)
    }
    
    let store: AddStore
    
    init(store: AddStore) {
        self.store = store
    }
    
    func goTo(item: SheetsViewModel.Item) {
        store.delete()
    }
}

extension FinancesDB {
    var dto: SheetDTO {
        .init(
            id: .init(id),
            createdAt: creationDate
        )
    }
}
