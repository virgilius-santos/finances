import Foundation

public final class AddSheetPresenter {
    public typealias Store = AddSheetStore
    
    let display: AddSheetDisplay
    let store: Store
    let date: DateFactory
    let uuid: UUIDFactory
    
    public init(display: AddSheetDisplay, store: Store, date: @escaping DateFactory, uuid: @escaping UUIDFactory = UUID.init) {
        self.display = display
        self.store = store
        self.date = date
        self.uuid = uuid
    }
    
    public func load() {
        display.show(sheet: AddSheetViewModel(id: .init(uuid()), date: date()))
    }
    
    public func add(sheet: AddSheetViewModel, completion: @escaping (SheetError?) -> Void) {
        store.addSheet(sheet.dto, completion: { error in
            completion(error)
        })
    }
}
