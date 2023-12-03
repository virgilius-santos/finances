import Foundation

public class SheetPresenter {
    let store: SheetStore
    let display: SheetDisplay
    
    public init(store: SheetStore, display: SheetDisplay) {
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
                    items: sheets.map(\.viewModel)
                ))
            case .failure:
                self.display.showError()
            }
        }
    }
    
    public func delete(item: SheetsViewModel.Item) {
        store.remove(sheetID: .init(item.id.value)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(true):
                self.load()
            case .success:
                break
            case .failure:
                self.display.showError()
            }
        }
    }
}

public extension SheetDTO {
    var viewModel: SheetsViewModel.Item {
        SheetsViewModel.Item(
            id: id.viewModel
        )
    }
}

public extension SheetDTO.ID {
    var viewModel: SheetsViewModel.Item.ID {
        .init(value)
    }
}
