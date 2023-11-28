import Foundation

public class SheetPresenter {
    let store: SheetStore
    let display: SheetDisplay
    
    init(store: SheetStore, display: SheetDisplay) {
        self.store = store
        self.display = display
    }
    
    func load() {
        store.getSheets { result in
            switch result {
            case let .success(sheets) where sheets.isEmpty:
                self.display.showEmptyData()
            case let .success(sheets):
                self.display.show(sheets: .init(
                    items: sheets.map {
                        SheetsViewModel.Item(id: $0.id)
                    }
                ))
            case .failure:
                self.display.showError()
            }
        }
    }
}
