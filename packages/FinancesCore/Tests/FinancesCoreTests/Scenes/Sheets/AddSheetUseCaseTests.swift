import XCTest
import FinancesCore
import FinancesCoreSharedTests

public final class AddSheetDisplayMock: AbstractDouble, AddSheetDisplay {
    public lazy var showSheetImpl: (_ sheets: AddSheetViewModel) -> Void = { [file, line] _ in
        XCTFail("\(Self.self).showSheet not implemented", file: file, line: line)
    }
    public func show(sheet: AddSheetViewModel) {
        showSheetImpl(sheet)
    }
}

final class AddSheetUseCaseTests: XCTestCase {
    func testOnAppear_ShouldSetCurrentDate() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureDisplayToReceive(doubles.viewModelMock)
            },
            .Step(
                when: { sut, doubles in
                    sut.load()
                },
                eventsExpected: ["sheet loaded"]
            )
        )
    }
    
    func testAddSheet_ShouldStore() throws {
        let (sut, doubles) = makeSut()
        let dtoMock = doubles.viewModelMock.dto
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureStoreToReceive(dtoMock, andCompletingWith: nil)
            },
            .Step(
                when: { sut, doubles in
                    sut.add(sheet: doubles.viewModelMock) { [weak doubles] error in
                        XCTAssertNil(error)
                        doubles?.events.append("scene completed")
                    }
                },
                eventsExpected: ["store requested"]
            ),
            .And(
                when: { sut, doubles in
                    doubles.receiveAsyncAddSheetResult()
                },
                eventsExpected: ["store completed", "scene completed"]
            )
        )
    }
    
    func testAddSheet_WhenFail_ShouldStore() throws {
        let (sut, doubles) = makeSut()
        let dtoMock = doubles.viewModelMock.dto
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureStoreToReceive(dtoMock, andCompletingWith: .generic)
            },
            .Step(
                when: { sut, doubles in
                    sut.add(sheet: doubles.viewModelMock) { [weak doubles] errorReceived in
                        XCTAssertEqual(errorReceived, SheetError.generic, "error invalid")
                        doubles?.events.append("scene completed")
                    }
                },
                eventsExpected: ["store requested"]
            ),
            .And(
                when: { sut, doubles in
                    doubles.receiveAsyncAddSheetResult()
                },
                eventsExpected: ["store completed", "scene completed"]
            )
        )
    }
}

private extension AddSheetUseCaseTests {
    typealias SUT = AddSheetPresenter
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        lazy var display = AddSheetDisplayMock(file: file, line: line)
        lazy var dateFactory: () -> Date = { Date(timeIntervalSince1970: 200) }
        lazy var uuidFactory: () -> UUID = { .fixture() }
        
        var viewModelMock: AddSheetViewModel {
            AddSheetViewModel(id: .init(uuidFactory()), date: dateFactory())
        }
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT(display: doubles.display, store: doubles.store, date: doubles.dateFactory, uuid: doubles.uuidFactory)
        verifyMemoryLeak(for: sut, file: file, line: line)
        verifyMemoryLeak(for: doubles.display, file: file, line: line)
        verifyMemoryLeak(for: doubles.store, file: file, line: line)
        return (sut, doubles)
    }
}

extension AddSheetUseCaseTests.Doubles {
    func configureDisplayToReceive(_ sheet: AddSheetViewModel, file: StaticString = #filePath, line: UInt = #line) {
        display.showSheetImpl = { [weak self] sheetReceived in
            XCTAssertEqual(sheetReceived, sheet, file: file, line: line)
            self?.events.append("sheet loaded")
        }
    }
    
    func configureStoreToReceive(_ sheet: SheetDTO, andCompletingWith result: AddSheetStore.AddSheetResult, file: StaticString = #filePath, line: UInt = #line) {
        store.configureAddSheet(
            expecting: sheet,
            toCompleteWith: result,
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func receiveAsyncAddSheetResult() {
        events = []
        store.addSheetCompletion?()
    }
}
