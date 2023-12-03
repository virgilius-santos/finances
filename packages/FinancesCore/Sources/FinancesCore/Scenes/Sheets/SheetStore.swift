import Foundation

public struct SheetDTO: Identifiable, Equatable {
    public typealias ID = EntityID<Self>
    
    public var id: ID
    
    public init(id: ID) {
        self.id = id
    }
}

public enum SheetError: Error, Equatable {
    case generic
}

public protocol SheetStore: AnyObject {
    typealias SheetsResult = Result<[SheetDTO], SheetError>
    func getSheets(completion: @escaping (SheetsResult) -> Void)
}
