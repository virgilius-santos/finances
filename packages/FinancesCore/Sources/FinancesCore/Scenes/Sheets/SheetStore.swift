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
    
    public init(id: ID) {
        self.id = id
    }
}

public extension SheetDTO {
    typealias ID = EntityID<Self>
}
