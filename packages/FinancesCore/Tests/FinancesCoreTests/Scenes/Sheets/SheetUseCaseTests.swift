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
            when: { sut, _ in sut.load() },
            expectEvents: ["store data request"]
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
            when: { sut, _ in sut.load() },
            expectEvents: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                expectEvents: ["getSheets sent", "display emptyData"]
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
            when: { sut, _ in sut.load() },
            expectEvents: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                expectEvents: ["getSheets sent", "display error"]
            )
        )
    }
    
    func testLoad_WhenHasSheets_ShouldDisplaySheets() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                let dto = SheetDTO.fixture(id: UUID())
                doubles.getSheetsResult = .success([dto])
                let viewModel = SheetsViewModel.fixture(items: [.fixture(id: dto.id)])
                doubles.sheetsToTeceive = viewModel
                doubles.configureGetSheets()
                doubles.configureDisplaySheets()
            },
            when: { sut, _ in sut.load() },
            expectEvents: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveAsyncSheetResult() },
                expectEvents: ["getSheets sent", "display sheets"]
            )
        )
    }
}

private extension SheetUseCaseTests {
    typealias SUT = SheetPresenter
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        
        var getSheetsResult = SheetStore.SheetsResult.success([])
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
        
        lazy var display = SheetDisplayMock(file: file, line: line)
        
        func configureDisplayEmptyData() {
            display.configureDisplayEmptyData { [weak self] in
                self?.events.append($0)
            }
        }
        
        var sheetsToTeceive = SheetsViewModel.fixture()
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
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT(store: doubles.store, display: doubles.display)
        verifyMemoryLeak(for: sut, file: file, line: line)
        verifyMemoryLeak(for: doubles.display, file: file, line: line)
        verifyMemoryLeak(for: doubles.store, file: file, line: line)
        return (sut, doubles)
    }
}
