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
}

final class StoreImpl: SheetStore, AddStore {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getSheets(completion: @escaping (GetSheetsResult) -> Void) {
        let descriptor = FetchDescriptor<FinancesDB>()
        let list: [FinancesDB] = (try? modelContext.fetch(descriptor)) ?? []
        completion(.success(list.map(\.dto)))
    }
    
    func addNewSheet() {
        modelContext.insert(FinancesDB.init())
        try? modelContext.save()
    }
    
    func remove(sheetID: SheetDTO.ID, completion: @escaping (RemoveSheetResult) -> Void) {
        do {
            try modelContext.delete(model: FinancesDB.self, where: #Predicate { sheets in
                sheets.id == sheetID.value
            })
            try modelContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(.generic))
        }
    }
}

final class AppCoordinator: SheetCoordinator {
    let store: AddStore
    
    init(store: AddStore) {
        self.store = store
    }
    
    func goTo(item: SheetsViewModel.Item) {
    }
    
    func addNewSheet(completion: (NewSheetResult) -> Void) {
        store.addNewSheet()
        completion(true)
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
