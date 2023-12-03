import Foundation
import FinancesCore
import FinancesDB
import SwiftData

final class AppStore {
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addNewSheet() {
        modelContext.insert(FinancesDB.init())
        try? modelContext.save()
    }
}

extension AppStore: SheetStore {
    func getSheets(completion: @escaping (GetSheetsResult) -> Void) {
        do {
            let descriptor = FetchDescriptor<FinancesDB>()
            let sheets: [FinancesDB] = try modelContext.fetch(descriptor)
            completion(.success(sheets.map(\.dto)))
        } catch {
            completion(.failure(.generic))
        }
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

extension FinancesDB {
    var dto: SheetDTO {
        .init(
            id: .init(id),
            createdAt: creationDate
        )
    }
}
