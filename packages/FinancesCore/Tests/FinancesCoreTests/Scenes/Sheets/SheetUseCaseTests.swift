import XCTest
import FinancesCore
import FinancesCoreSharedTests

final class SheetUseCaseTests: XCTestCase {
    func testLoad_ShouldGetDataFromStore() throws {
        let (sut, doubles) = makeSut()

        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheets()
            },
            .Step(
                when: { sut, _ in sut.load() },
                eventsExpected: ["store data request"]
            )
        )
    }
    
    func testLoad_WhenEmpty_ShouldDisplayEmptyState() throws {
        let (sut, doubles) = makeSut()

        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.getSheetsResult = .success([])
                doubles.configureGetSheets()
                doubles.configureDisplayEmptyData()
            },
            .Step(
                when: { sut, _ in sut.load() },
                eventsExpected: ["store data request"]
            ),
            .And(
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                eventsExpected: ["getSheets sent", "display emptyData"]
            )
        )
    }
    
    func testLoad_WhenError_ShouldDisplayError() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.getSheetsResult = .failure(.generic)
                doubles.configureGetSheets()
                doubles.configureDisplayError()
            },
            .Step(
                when: { sut, _ in sut.load() },
                eventsExpected: ["store data request"]
            ),
            .And(
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                eventsExpected: ["getSheets sent", "display error"]
            )
        )
    }
    
    func testLoad_WhenHasSheets_ShouldDisplaySheets() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                let dto = SheetDTO.fixture(id: .fixture(id: UUID()))
                doubles.getSheetsResult = .success([dto])
                let viewModel = SheetsViewModel.fixture(items: [dto.viewModel])
                doubles.sheetsToTeceive = viewModel
                doubles.configureGetSheets()
                doubles.configureDisplaySheets()
            },
            .Step(
                when: { sut, _ in sut.load() },
                eventsExpected: ["store data request"]
            ),
            .And(
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                eventsExpected: ["getSheets sent", "display sheets"]
            )
        )
    }
}

private extension SheetUseCaseTests {
    typealias SUT = SheetsPresenter
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        lazy var display = SheetDisplayMock(file: file, line: line)
        
        var getSheetsResult = SheetStoreMock.GetSheetsResult.success([])
        var sheetsToTeceive = SheetsViewModel.fixture()
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT(store: doubles.store, display: doubles.display)
        verifyMemoryLeak(for: sut, file: file, line: line)
        verifyMemoryLeak(for: doubles.display, file: file, line: line)
        verifyMemoryLeak(for: doubles.store, file: file, line: line)
        return (sut, doubles)
    }
}

private extension SheetUseCaseTests.Doubles {
    func configureGetSheets() {
        store.configureGetSheets(
            toCompleteWith: getSheetsResult,
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func receiveAsyncSheetResult() {
        events = []
        store.getSheetsCompletion?()
    }
    
    func configureDisplayEmptyData() {
        display.configureDisplayEmptyData { [weak self] in
            self?.events.append($0)
        }
    }
    
    func configureDisplaySheets() {
        display.configureDisplaySheets(toReceive: sheetsToTeceive) { [weak self] in
            self?.events.append($0)
        }
    }
    
    func configureDisplayError() {
        display.configureDisplayError { [weak self] in
            self?.events.append($0)
        }
    }
}
