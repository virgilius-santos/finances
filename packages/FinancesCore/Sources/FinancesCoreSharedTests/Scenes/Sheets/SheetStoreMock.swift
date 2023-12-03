import XCTest
import FinancesCore

public class SheetStoreMock: AbstractDouble, SheetStore {
    public lazy var getSheetsImpl: (_ completion: @escaping (SheetsResult) -> Void) -> Void = { [file, line] _ in
            XCTFail("\(Self.self).getSheets not implemented", file: file, line: line)
        }
    public func getSheets(completion: @escaping (SheetsResult) -> Void) {
        getSheetsImpl(completion)
    }
    
    public var getSheetsCompletion: (() -> Void)?
    public func configureGetSheets(
        toCompleteWith resultList: SheetStore.SheetsResult,
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
    static func fixture(id: UUID = .fixture()) -> Self {
        .init(id: id)
    }
}
