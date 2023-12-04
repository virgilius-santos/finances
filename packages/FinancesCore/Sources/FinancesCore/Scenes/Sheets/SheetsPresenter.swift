import Foundation

public class SheetsPresenter {
    let store: SheetStore
    let display: SheetsDisplay
    
    public init(store: SheetStore, display: SheetsDisplay) {
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
            id: id.viewModel,
            createdAt: createdAt
        )
    }
}

public extension SheetDTO.ID {
    var viewModel: SheetsViewModel.Item.ID {
        .init(value)
    }
}
