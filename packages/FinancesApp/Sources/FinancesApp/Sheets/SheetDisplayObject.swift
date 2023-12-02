import FinancesCore

public final class SheetDisplayObject: SheetDisplay {
    public weak var viewModel: SheetDisplay?
    
    public init(viewModel: SheetDisplay? = nil) {
        self.viewModel = viewModel
    }
    
    public func showEmptyData() {
        viewModel?.showEmptyData()
    }
    
    public func show(sheets: SheetsViewModel) {
        viewModel?.show(sheets: sheets)
    }
    
    public func showError() {
        viewModel?.showError()
    }
}
