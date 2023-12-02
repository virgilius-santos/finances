import XCTest
import FinancesApp
import FinancesCore
import FinancesCoreSharedTests

public final class SheetsCoordinatorMock: AbstractDouble, SheetCoordinator {
    public lazy var addNewSheetImpl: () -> Void = { [file, line] in
        XCTFail("\(Self.self).addNewSheet not implemented", file: file, line: line)
    }
    public func addNewSheet() {
        addNewSheetImpl()
    }
    
    public lazy var goToSheetImpl: (_ item: SheetsViewModel.Item) -> Void = { [file, line] _ in
        XCTFail("\(Self.self).goToSheet not implemented", file: file, line: line)
    }
    public func goTo(item: SheetsViewModel.Item) {
        goToSheetImpl(item)
    }
}
