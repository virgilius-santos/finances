import XCTest
import FinancesApp
import FinancesCore
import FinancesCoreSharedTests
import ViewInspector
import SwiftUI

final class SheetsViewTests: XCTestCase {
    func testInit_ShouldShowEmptyState() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            step: .init(
                when: { sut, doubles in
                    try sut.findValue(for: "EmptyState.Text")
                },
                then: { text in
                    XCTAssertEqual(text, "Crie sua primeira Planilha de Gastos")
                }
            )
        )
    }
    
    func testClickOnAddButton_ShouldShowLoadSheet() throws {
        let (sut, doubles) = makeSut()
        let listMock = [
            SheetDTO.fixture(id: .init()),
            .fixture(id: .init())
        ]
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureShowNewSheetScene(completeWith: true)
                doubles.configureGetSheetsToCompleteWith(list: listMock)
            },
            step: .init(
                when: { sut, doubles in
                    try sut.tap(onLabel: "Add Sheet")
                },
                eventsExpected: ["add new sheet request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncAddNewSheetResult()
                },
                eventsExpected: ["addNewSheet sent", "store data request"]
            )
        )
    }
    
    func testClickOnAddButton_WhenFail_ShouldShowNotLoadSheets() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureShowNewSheetScene(completeWith: false)
            },
            step: .init(
                when: { sut, doubles in
                    try sut.tap(onLabel: "Add Sheet")
                },
                eventsExpected: ["add new sheet request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncAddNewSheetResult()
                },
                eventsExpected: ["addNewSheet sent"]
            )
        )
    }
            
    func testOnAppear_WhenLoadEmptyList_ShouldShowEmptyState() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheetsToCompleteWithEmptyState()
            },
            step: .init(
                when: { sut, doubles in
                    try sut.callOnAppear()
                },
                eventsExpected: ["store data request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncSheetResult()
                },
                eventsExpected: ["getSheets sent"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.cleanEvents()
                    return try sut.findValue(for: "EmptyState.Text")
                },
                then: { text in
                    XCTAssertEqual(text, "Crie sua primeira Planilha de Gastos")
                },
                eventsExpected: []
            )
        )
    }
    
    func testOnAppear_WhenLoadList_ShouldShowItems() throws {
        let (sut, doubles) = makeSut()
        let listMock = [
            SheetDTO.fixture(id: .init()),
            .fixture(id: .init())
        ]
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheetsToCompleteWith(list: listMock)
            },
            step: .init(
                when: { sut, doubles in
                    try sut.callOnAppear()
                },
                eventsExpected: ["store data request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncSheetResult()
                },
                eventsExpected: ["getSheets sent"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.cleanEvents()
                    return try sut.getListRowsIds(numberOfRows: listMock.count)
                },
                then: { rows in
                    XCTAssertEqual(rows, listMock.map(\.id.value.uuidString))
                }
            )
        )
    }
    
    func testOnAppear_WhenLoadListWithErrot_ShouldAlert() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheetsToCompleteWithError()
            },
            step: .init(
                when: { sut, doubles in
                    try sut.callOnAppear()
                },
                eventsExpected: ["store data request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncSheetResult()
                },
                eventsExpected: ["getSheets sent"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.cleanEvents()
                    return try sut.inspect().group().alert()
                },
                then: { alert in
                    XCTAssertEqual(try alert.title().string(), "Deu Ruim")
                }
            )
        )
    }
    
    func testOnItemClick_ShouldShowDetails() throws {
        let (sut, doubles) = makeSut()
        let listMock = [
            SheetDTO.fixture(id: .init()),
            .fixture(id: .init())
        ]
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheetsToCompleteWith(list: listMock)
                doubles.configureShowSheetScene(expecting: listMock[0].viewModel)
            },
            step: .init(
                when: { sut, doubles in
                    try sut.callOnAppear()
                },
                eventsExpected: ["store data request"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.receiveAsyncSheetResult()
                },
                eventsExpected: ["getSheets sent"]
            ),
            .init(
                when: { sut, doubles in
                    doubles.cleanEvents()
                    return try sut.tap(onID: "\(listMock[0].id)")
                },
                eventsExpected: ["GoToSheet"]
            )
        )
    }
}

private extension SheetsViewTests {
    typealias SUT = SheetsView
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        lazy var coordinator = SheetsCoordinatorMock(file: file, line: line)
        
        lazy var viewModel: SheetsView.ViewModel = { doubles in
            let object = SheetsDisplayObject()
            let presenter = SheetsPresenter(store: doubles.store, display: object)
            let viewModel = SUT.ViewModel(presenter: presenter, coordinator: doubles.coordinator)
            object.viewModel = viewModel
            doubles.expectEvents([])
            return viewModel
        }(self)
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT(viewModel: doubles.viewModel)
        verifyMemoryLeak(for: doubles.coordinator, file: file, line: line)
        verifyMemoryLeak(for: doubles.store, file: file, line: line)
        verifyMemoryLeak(for: doubles.viewModel, file: file, line: line)
        return (sut, doubles)
    }
}

private extension SheetsViewTests.Doubles {
    func configureShowNewSheetScene(completeWith result: Bool) {
        coordinator.configureaddNewSheet(
            toCompleteWith: result,
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func receiveAsyncAddNewSheetResult() {
        events = []
        coordinator.addNewSheetCompletion?()
    }
    
    func configureGetSheetsToCompleteWithEmptyState() {
        store.configureGetSheets(
            toCompleteWith: SheetStoreMock.GetSheetsResult.success([]),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func configureGetSheetsToCompleteWith(list: [SheetDTO]) {
        store.configureGetSheets(
            toCompleteWith: .success(list),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func configureGetSheetsToCompleteWithError() {
        store.configureGetSheets(
            toCompleteWith: .failure(.generic),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func receiveAsyncSheetResult() {
        events = []
        store.getSheetsCompletion?()
    }
    
    func configureShowSheetScene(expecting itemExpected: SheetsViewModel.Item, file: StaticString = #filePath, line: UInt = #line) {
        coordinator.goToSheetImpl = { [weak self] item in
            XCTAssertEqual(item , itemExpected, "invalid item received", file: file, line: line)
            self?.events.append("GoToSheet")
        }
    }
}
