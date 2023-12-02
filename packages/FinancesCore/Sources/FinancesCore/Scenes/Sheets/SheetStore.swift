import Foundation

public struct SheetDTO: Identifiable, Equatable {
    public var id: UUID
    
    public init(id: UUID) {
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
