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

extension AppStore: GetSheetStore {
    func getSheets(completion: @escaping (GetSheetsResult) -> Void) {
        do {
            let descriptor = FetchDescriptor<FinancesDB>()
            let sheets: [FinancesDB] = try modelContext.fetch(descriptor)
            completion(.success(sheets.map(\.dto)))
        } catch {
            completion(.failure(.generic))
        }
    }
}

extension AppStore: RemoveSheetStore {
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

extension AppStore: AddSheetStore {
    func addSheet(_ sheet: SheetDTO, completion: @escaping (AddSheetResult) -> Void) {
        do {
            modelContext.insert(sheet.db)
            try modelContext.save()
            completion(nil)
        } catch {
            completion(.generic)
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

extension SheetDTO {
    var db: FinancesDB {
        .init(creationDate: createdAt, id: id.value)
    }
}
