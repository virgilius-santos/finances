import Foundation

public extension SheetDisplay {
    var thread: SheetDisplay {
        SheetDisplayThread(viewModel: self)
    }
}

public final class SheetDisplayThread: SheetDisplay {
    public let viewModel: SheetDisplay
    
    public init(viewModel: SheetDisplay) {
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
