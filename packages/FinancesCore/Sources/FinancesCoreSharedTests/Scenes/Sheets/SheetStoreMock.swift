import XCTest
import FinancesCore

public class SheetStoreMock: AbstractDouble, GetSheetStore, RemoveSheetStore, AddSheetStore {
    // MARK: Add
    public lazy var addSheetImpl: (_ sheet: SheetDTO, _ completion: @escaping (AddSheetResult) -> Void) -> Void = { [file, line] _, _ in
        XCTFail("\(Self.self).addSheet not implemented", file: file, line: line)
    }
    public func addSheet(_ sheet: SheetDTO, completion: @escaping (AddSheetResult) -> Void) {
        addSheetImpl(sheet, completion)
    }
    
    public var addSheetCompletion: (() -> Void)?
    public func configureAddSheet(
        expecting sheet: SheetDTO,
        toCompleteWith result: AddSheetResult,
        sendMessage: @escaping (String) -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addSheetImpl = { [weak self] sheetReceived, completion in
            XCTAssertEqual(sheetReceived, sheet, "invalid sheet received", file: file, line: line)
            self?.addSheetCompletion = {
                sendMessage("store completed")
                completion(result)
            }
            sendMessage("store requested")
        }
    }
    
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
