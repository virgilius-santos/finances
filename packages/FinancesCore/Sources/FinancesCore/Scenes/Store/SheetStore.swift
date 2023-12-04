import Foundation

public protocol GetSheetStore: AnyObject {
    typealias GetSheetsResult = Result<[SheetDTO], SheetError>
    func getSheets(completion: @escaping (GetSheetsResult) -> Void)
}

public protocol RemoveSheetStore: AnyObject {
    typealias RemoveSheetResult = Result<Bool, SheetError>
    func remove(sheetID: SheetDTO.ID, completion: @escaping (RemoveSheetResult) -> Void)
}

public enum SheetError: Error, Equatable {
    case generic
}

public struct SheetDTO: Identifiable, Equatable {
    public var id: ID
    public var createdAt: Date
    
    public init(id: ID, createdAt: Date) {
        self.id = id
        self.createdAt = createdAt
    }
}

public extension SheetDTO {
    typealias ID = EntityID<Self>
}
