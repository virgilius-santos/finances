import Foundation

public struct SheetsViewModel: Equatable {
    public struct Item: Identifiable, Equatable {
        public typealias ID = EntityID<Self>
        
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

public protocol SheetDisplay: AnyObject {
    func showEmptyData()
    func show(sheets: SheetsViewModel)
    func showError()
}
