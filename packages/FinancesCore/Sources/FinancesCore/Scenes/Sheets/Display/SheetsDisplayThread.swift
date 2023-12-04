import Foundation

public extension SheetsDisplay {
    var thread: SheetsDisplay {
        SheetsDisplayThread(viewModel: self)
    }
}

public final class SheetsDisplayThread: SheetsDisplay {
    public let viewModel: SheetsDisplay
    
    public init(viewModel: SheetsDisplay) {
        self.viewModel = viewModel
    }
    
    public func showEmptyData() {
        DispatchQueue.main.async {
            self.viewModel.showEmptyData()
        }
    }
    
    public func show(sheets: SheetsViewModel) {
        DispatchQueue.main.async {
            self.viewModel.show(sheets: sheets)
        }
    }
    
    public func showError() {
        DispatchQueue.main.async {
            self.viewModel.showError()
        }
    }
}
