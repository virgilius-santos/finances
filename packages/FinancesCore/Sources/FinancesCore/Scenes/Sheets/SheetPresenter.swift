import Foundation

public class SheetPresenter {
    let store: GetSheetsStore
    let display: SheetDisplay
    
    public init(store: GetSheetsStore, display: SheetDisplay) {
        self.store = store
        self.display = display
    }
    
    public func load() {
        store.getSheets { [weak self] result in
            guard let self else { return }
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
