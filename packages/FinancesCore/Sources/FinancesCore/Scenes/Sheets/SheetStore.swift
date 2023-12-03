import Foundation

public protocol SheetStore: AnyObject {
    typealias SheetsResult = Result<[SheetDTO], SheetError>
    func getSheets(completion: @escaping (SheetsResult) -> Void)
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
