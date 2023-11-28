import Foundation

public struct SheetsViewModel: Equatable {
    public struct Item: Identifiable, Equatable {
        public var id: UUID
        
        public init(id: UUID) {
            self.id = id
        }
    }
    
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

public protocol SheetDisplay {
    func showEmptyData()
    func show(sheets: SheetsViewModel)
    func showError()
}
