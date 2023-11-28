import XCTest
import FinancesCore

public class SheetStoreMock: SheetStore {
    let file: StaticString
    let line: UInt
    
    init(file: StaticString = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line
    }
    
    public lazy var getSheetsImpl: (_ completion: @escaping (SheetsResult) -> Void) -> Void = { [file, line] _ in
            XCTFail("\(Self.self).getSheets not implemented", file: file, line: line)
        }
    public typealias SheetsResult = Result<[SheetDTO], SheetError>
    public func getSheets(completion: @escaping (SheetsResult) -> Void) {
        getSheetsImpl(completion)
    }
}

extension SheetDTO {
    static func fixture(id: UUID = .fixture()) -> Self {
        .init(id: id)
    }
}
