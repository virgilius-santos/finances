import Foundation

public protocol AddSheetDisplay {
    func show(sheet: AddSheetViewModel)
}

public struct AddSheetViewModel: Equatable {
    public typealias ID = EntityID<Self>
    
    public let id: ID
    public let date: Date
    
    public init(id: ID, date: Date) {
        self.id = id
        self.date = date
    }
}

public extension AddSheetViewModel {
    var dto: SheetDTO {
        .init(id: id.dto, createdAt: date)
    }
}

public extension AddSheetViewModel.ID {
    var dto: SheetDTO.ID {
        .init(value)
    }
}
