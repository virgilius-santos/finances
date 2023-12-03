import XCTest
import FinancesCore

public class SheetStoreMock: AbstractDouble, SheetStore {
    public lazy var getSheetsImpl: (_ completion: @escaping (GetSheetsResult) -> Void) -> Void = { [file, line] _ in
            XCTFail("\(Self.self).getSheets not implemented", file: file, line: line)
        }
    public func getSheets(completion: @escaping (GetSheetsResult) -> Void) {
        getSheetsImpl(completion)
    }
    
    public var getSheetsCompletion: (() -> Void)?
    public func configureGetSheets(
        toCompleteWith resultList: GetSheetsResult,
        sendMessage: @escaping (String) -> Void
    ) {
        getSheetsImpl = { [weak self] completion in
            self?.getSheetsCompletion = {
                sendMessage("getSheets sent")
                completion(resultList)
            }
            sendMessage("store data request")
        }
    }
}

public extension SheetDTO {
    static func fixture(id: ID = .fixture()) -> Self {
        .init(id: id, createdAt: .fixture())
    }
}
