import Foundation

public final class SheetsDisplayObject: SheetsDisplay {
    public weak var viewModel: SheetsDisplay?
    
    public init(viewModel: SheetsDisplay? = nil) {
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
