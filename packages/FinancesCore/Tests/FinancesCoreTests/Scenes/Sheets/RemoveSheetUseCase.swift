import XCTest
import FinancesCore
import FinancesCoreSharedTests

final class RemoveSheetUseCase: XCTestCase {
    func testRemove_ShouldRemoveFromStore_AndReloadData() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureRemoveSheetsToCompleteWithTrue()
            },
            step: .init(
                when: { sut, doubles in
                    sut.delete(item: doubles.itemMock)
                },
                eventsExpected: ["remove data request"]
            ),
            .init(
                when: { _, doubles in
                    doubles.receiveAsyncRemoveSheetResult()
                },
                eventsExpected: ["remove sheet completed", "store data request"]
            )
        )
    }
    
    func testRemove_WhenReturnFalse_ShouldNotReloadData() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureRemoveSheetsToCompleteWithFalse()
            },
            step: .init(
                when: { sut, doubles in
                    sut.delete(item: doubles.itemMock)
                },
                eventsExpected: ["remove data request"]
            ),
            .init(
                when: { _, doubles in
                    doubles.receiveAsyncRemoveSheetResult()
                },
                eventsExpected: ["remove sheet completed"]
            )
        )
    }
    
    func testRemove_WhenFail_ShouldShowBanner() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureRemoveSheetsToFail()
            },
            step: .init(
                when: { sut, doubles in
                    sut.delete(item: doubles.itemMock)
                },
                eventsExpected: ["remove data request"]
            ),
            .init(
                when: { _, doubles in
                    doubles.receiveAsyncRemoveSheetResult()
                },
                eventsExpected: ["remove sheet completed", "ShowError called"]
            )
        )
    }
}

private extension RemoveSheetUseCase {
    typealias SUT = SheetPresenter
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        lazy var display = SheetDisplayMock(file: file, line: line)
        
        lazy var itemMock = SheetsViewModel.Item.fixture(id: .init())
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

private extension RemoveSheetUseCase.Doubles {
    func configureRemoveSheetsToCompleteWithTrue(file: StaticString = #filePath, line: UInt = #line) {
        store.configureRemoveSheet(
            expecting: .init(itemMock.id.value),
            toCompleteWith: .success(true),
            sendMessage: { [weak self] in self?.events.append($0) },
            file: file,
            line: line
        )
        store.configureGetSheets(
            toCompleteWith: .failure(.generic),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func configureRemoveSheetsToCompleteWithFalse(file: StaticString = #filePath, line: UInt = #line) {
        store.configureRemoveSheet(
            expecting: .init(itemMock.id.value),
            toCompleteWith: .success(false),
            sendMessage: { [weak self] in self?.events.append($0) },
            file: file,
            line: line
        )
    }
    
    func configureRemoveSheetsToFail(file: StaticString = #filePath, line: UInt = #line) {
        store.configureRemoveSheet(
            expecting: .init(itemMock.id.value),
            toCompleteWith: .failure(.generic),
            sendMessage: { [weak self] in self?.events.append($0) },
            file: file,
            line: line
        )
        display.showErrorImpl = { [weak self] in
            self?.events.append("ShowError called")
        }
    }
    
    func receiveAsyncRemoveSheetResult() {
        events = []
        store.removeSheetCompletion?()
    }
}
