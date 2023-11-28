import XCTest
import FinancesCore

public class SheetDisplayMock: SheetDisplay {
    let file: StaticString
    let line: UInt
    
    public init(file: StaticString = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line
    }
    
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
}

public extension SheetsViewModel {
    static func fixture(items: [SheetsViewModel.Item] = []) -> Self {
        .init(items: items)
    }
}

public extension SheetsViewModel.Item {
    static func fixture(id: UUID = .fixture()) -> Self {
        .init(id: id)
    }
}
