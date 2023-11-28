import XCTest
import FinancesCore

public class SheetStoreMock: SheetStore {
    let file: StaticString
    let line: UInt
    
    public init(file: StaticString = #filePath, line: UInt = #line) {
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
    
    public var getSheetsCompletion: (() -> Void)?
    public func configureGetSheets(
        toCompleteWith result: SheetStore.SheetsResult = .success([]),
        sendMessage: @escaping (String) -> Void
    ) {
        getSheetsImpl = { [weak self] completion in
            self?.getSheetsCompletion = { completion(result) }
            sendMessage("store data request")
        }
    }
}

public extension SheetDTO {
    static func fixture(id: UUID = .fixture()) -> Self {
        .init(id: id)
    }
}
