import XCTest
import FinancesCore

public class SheetDisplayMock: AbstractDouble, SheetsDisplay {
    public lazy var showEmptyDataImpl: () -> Void = { [file, line] in
        XCTFail("\(Self.self).showEmptyData not implemented", file: file, line: line)
    }
    public func showEmptyData() {
        showEmptyDataImpl()
    }
    
    public lazy var showSheetsImpl: (_ sheets: SheetsViewModel) -> Void = { [file, line] _ in
        XCTFail("\(Self.self).getSheets not implemented", file: file, line: line)
    }
    public func show(sheets: SheetsViewModel) {
        showSheetsImpl(sheets)
    }
    
    public lazy var showErrorImpl: () -> Void = { [file, line] in
        XCTFail("\(Self.self).showError not implemented", file: file, line: line)
    }
    public func showError() {
        showErrorImpl()
    }
    
    public func configureDisplayEmptyData(sendMessage: @escaping (String) -> Void) {
        showEmptyDataImpl = {
            sendMessage("display emptyData")
        }
    }
    
    public func configureDisplaySheets(
        toReceive sheets: SheetsViewModel,
        sendMessage: @escaping (String) -> Void
    ) {
        showSheetsImpl = { [file, line] sheetsReceived in
            XCTAssertEqual(sheetsReceived, sheets, "invalid sheets received", file: file, line: line)
            sendMessage("display sheets")
        }
    }
    
    public func configureDisplayError(sendMessage: @escaping (String) -> Void) {
        showErrorImpl = {
            sendMessage("display error")
        }
    }
}

public extension SheetsViewModel {
    static func fixture(items: [SheetsViewModel.Item] = []) -> Self {
        .init(items: items)
    }
}

public extension SheetsViewModel.Item {
    static func fixture(id: ID = .fixture()) -> Self {
        .init(id: id, createdAt: .fixture())
    }
}
