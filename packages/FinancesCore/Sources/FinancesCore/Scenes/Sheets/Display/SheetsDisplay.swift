import Foundation

public protocol SheetsDisplay: AnyObject {
    func showEmptyData()
    func show(sheets: SheetsViewModel)
    func showError()
}

public struct SheetsViewModel: Equatable {
    public struct Item: Identifiable, Equatable {
        public var id: ID
        public var createdAt: Date
        
        public init(id: ID, createdAt: Date) {
            self.id = id
            self.createdAt = createdAt
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
