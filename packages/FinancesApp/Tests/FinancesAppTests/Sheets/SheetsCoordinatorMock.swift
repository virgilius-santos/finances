import XCTest
import FinancesApp
import FinancesCore
import FinancesCoreSharedTests

public final class SheetsCoordinatorMock: AbstractDouble, SheetCoordinator {
    public lazy var addNewSheetImpl: (_ completion: @escaping (NewSheetResult) -> Void) -> Void = { [file, line] _ in
        XCTFail("\(Self.self).addNewSheet not implemented", file: file, line: line)
    }
    public func addNewSheet(completion: @escaping (NewSheetResult) -> Void) {
        addNewSheetImpl(completion)
    }
    
    public var addNewSheetCompletion: (() -> Void)?
    public func configureaddNewSheet(
        toCompleteWith result: NewSheetResult,
        sendMessage: @escaping (String) -> Void
    ) {
        addNewSheetImpl = { [weak self] completion in
            self?.addNewSheetCompletion = {
                sendMessage("addNewSheet sent")
                completion(result)
            }
            sendMessage("add new sheet request")
        }
    }
    
    public lazy var goToSheetImpl: (_ item: SheetsViewModel.Item) -> Void = { [file, line] _ in
        XCTFail("\(Self.self).goToSheet not implemented", file: file, line: line)
    }
    public func goTo(item: SheetsViewModel.Item) {
        goToSheetImpl(item)
    }
}
