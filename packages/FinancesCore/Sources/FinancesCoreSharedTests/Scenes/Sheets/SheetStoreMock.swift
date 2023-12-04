import XCTest
import FinancesCore

public class SheetStoreMock: AbstractDouble, GetSheetStore, RemoveSheetStore, AddSheetStore {
    // MARK: Get
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
    
    // MARK: Remove
    public lazy var removeSheetImpl: (_ sheetID: SheetDTO.ID, _ completion: @escaping (RemoveSheetResult) -> Void) -> Void = { [file, line] _, _ in
        XCTFail("\(Self.self).removeSheet not implemented", file: file, line: line)
    }
    public func remove(sheetID: SheetDTO.ID, completion: @escaping (RemoveSheetResult) -> Void) {
        removeSheetImpl(sheetID, completion)
    }
    
    public var removeSheetCompletion: (() -> Void)?
    public func configureRemoveSheet(
        expecting id: SheetDTO.ID,
        toCompleteWith result: RemoveSheetResult,
        sendMessage: @escaping (String) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        removeSheetImpl = { [weak self] idReceived, completion in
            XCTAssertEqual(idReceived, id, "invalid id received", file: file, line: line)
            self?.removeSheetCompletion = {
                sendMessage("remove sheet completed")
                completion(result)
            }
            sendMessage("remove data request")
        }
    }
}

public extension SheetDTO {
    static func fixture(id: ID = .fixture()) -> Self {
        .init(id: id, createdAt: .fixture())
    }
}
