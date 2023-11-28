import XCTest
@testable import FinancesCore

final class SheetUseCaseTests: XCTestCase {
    func testLoad_ShouldGetDataFromStore() throws {
        let (sut, doubles) = makeSut()

        expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheets()
            },
            when: { sut, _ in sut.load() },
            expect: ["store data request"]
        )
    }
    
    func testLoad_WhenEmpty_ShouldDisplayEmptyState() throws {
        let (sut, doubles) = makeSut()

        expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheets(toCompleteWith: .success([]))
                doubles.configureDisplayEmptyData()
            },
            when: { sut, _ in sut.load() },
            expect: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveSheetResult() },
                expect: ["display emptyData"]
            )
        )
    }
    
    func testLoad_WhenError_ShouldDisplayError() throws {
        let (sut, doubles) = makeSut()
        
        expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheets(toCompleteWith: .failure(.generic))
                doubles.configureDisplayError()
            },
            when: { sut, _ in sut.load() },
            expect: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveSheetResult() },
                expect: ["display error"]
            )
        )
    }
    
    func testLoad_WhenHasSheets_ShouldDisplaySheets() {
        let (sut, doubles) = makeSut()
        
        expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                let dto = SheetDTO.fixture(id: UUID())
                let viewModel = SheetsViewModel.fixture(items: [.fixture(id: dto.id)])
                doubles.configureGetSheets(toCompleteWith: .success([dto]))
                doubles.configureDisplaySheets(toReceive: viewModel)
            },
            when: { sut, _ in sut.load() },
            expect: ["store data request"],
            and: (
                when: { _, doubles in doubles.receiveSheetResult() },
                expect: ["display sheets"]
            )
        )
    }
}

private extension SheetUseCaseTests {
    typealias SUT = SheetPresenter
    
    final class Doubles: EventsReceiver {
        let file: StaticString
        let line: UInt
        
        init(file: StaticString = #filePath, line: UInt = #line) {
            self.file = file
            self.line = line
        }
        
        var events = [String]()
        
        func expectEvents(_ eventsReceived: [String], file: StaticString = #filePath, line: UInt = #line) {
            XCTAssertEqual(events, eventsReceived, "invalid events received", file: file, line: line)
        }
        
        lazy var store = SheetStoreMock(file: file, line: line)
        
        private var getSheetsCompletion: (() -> Void)?
        func configureGetSheets(toCompleteWith result: SheetStore.SheetsResult = .success([])) {
            store.getSheetsImpl = { [weak self] completion in
                self?.getSheetsCompletion = { completion(result) }
                self?.events.append("store data request")
            }
        }
        
        func receiveSheetResult() {
            events = []
            getSheetsCompletion?()
        }
        
        lazy var display = SheetDisplayMock(file: file, line: line)
        
        func configureDisplayEmptyData() {
            display.showEmptyDataImpl = { [weak self] in
                self?.events.append("display emptyData")
            }
        }
        
        func configureDisplaySheets(toReceive sheets: SheetsViewModel) {
            display.showSheetsImpl = { [file, line, weak self] sheetsReceived in
                XCTAssertEqual(sheetsReceived, sheets, "invalid sheets received", file: file, line: line)
                self?.events.append("display sheets")
            }
        }
        
        func configureDisplayError() {
            display.showErrorImpl = { [weak self] in
                self?.events.append("display error")
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
