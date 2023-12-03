import Foundation

public protocol SheetDisplay: AnyObject {
    func showEmptyData()
    func show(sheets: SheetsViewModel)
    func showError()
}

public struct SheetsViewModel: Equatable {
    public struct Item: Identifiable, Equatable {
        public var id: ID
        
        public init(id: ID) {
            self.id = id
        }
    }
    
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

public extension SheetsViewModel.Item {
    typealias ID = EntityID<Self>
}
