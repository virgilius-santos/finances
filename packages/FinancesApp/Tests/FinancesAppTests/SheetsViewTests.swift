import XCTest
import FinancesApp
import FinancesCore
import FinancesCoreSharedTests
import ViewInspector
import SwiftUI

final class SheetDisplayObject: SheetDisplay {
    weak var viewModel: SheetsView.ViewModel?
    
    func showEmptyData() {
        viewModel?.setEmptyState()
    }
    
    func show(sheets: SheetsViewModel) {
        viewModel?.set(viewModel: sheets)
    }
    
    func showError() {}
}

final class SheetCoordinator: AbstractDouble {
    
    public lazy var addNewSheetImpl: () -> Void = { [file, line] in
        XCTFail("\(Self.self).addNewSheet not implemented", file: file, line: line)
    }
    func addNewSheet() {
        addNewSheetImpl()
    }
}

extension SheetsView {
    final class ViewModel: ObservableObject {
        @Published var title: String? = "Crie sua primeira Planilha de Gastos"
        @Published var items: [SheetsViewModel.Item] = []
        
        let presenter: SheetPresenter
        let coordinator: SheetCoordinator
        
        init(presenter: SheetPresenter, coordinator: SheetCoordinator) {
            self.presenter = presenter
            self.coordinator = coordinator
        }
        
        func setEmptyState() {
            title = "Crie sua primeira Planilha de Gastos"
        }
        
        func set(viewModel: SheetsViewModel) {
            title = nil
            items = viewModel.items
        }
        
        func load() {
            presenter.load()
        }
        
        func addNewSheet() {
            coordinator.addNewSheet()
        }
    }
}

struct SheetsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        Group {
            Button("Add Sheet") {
                viewModel.addNewSheet()
            }
            if let title = viewModel.title {
                EmptyTextView(title: title)
            }
            else {
                List(viewModel.items) { item in
                    Text(item.id.uuidString)
                }
                .accessibilityIdentifier("List.full")
            }
        }
        .onAppear {
            viewModel.load()
        }
    }
}

struct EmptyTextView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .accessibilityIdentifier("EmptyState.Text")
    }
}

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
    
    func testClickOnAddButton_ShouldShowAddSheet() throws {
        let (sut, doubles) = makeSut()
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureShowNewSheetScene()
            },
            step: .init(
                when: { sut, doubles in
                    try sut.tap(on: "Add Sheet")
                },
                eventsExpected: ["ShowAddSheet"]
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
        let listMock1 = [
            SheetDTO.fixture(id: .init()),
            .fixture(id: .init())
        ]
        let listMock2 = [
            SheetDTO.fixture(id: .init()),
            .fixture(id: .init()),
            .fixture(id: .init()),
            .fixture(id: .init())
        ]
        
        try expect(
            sut: sut,
            using: doubles,
            given: { doubles in
                doubles.configureGetSheetsUpdatableWith(list: listMock1, listMock2)
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
                    return try sut.getListRowsIds(numberOfRows: listMock1.count)
                },
                then: { rows in
                    XCTAssertEqual(rows, listMock1.map(\.id.uuidString))
                }
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
                    return try sut.getListRowsIds(numberOfRows: listMock2.count)
                },
                then: { rows in
                    XCTAssertEqual(rows, listMock2.map(\.id.uuidString))
                }
            )
        )
    }
}

private extension SheetsViewTests {
    typealias SUT = SheetsView
    
    final class Doubles: AbstractDouble {
        lazy var store = SheetStoreMock(file: file, line: line)
        lazy var coordinator = SheetCoordinator(file: file, line: line)
        
        lazy var viewModel: SheetsView.ViewModel = { doubles in
            let object = SheetDisplayObject()
            let presenter = SheetPresenter(store: doubles.store, display: object)
            let viewModel = SUT.ViewModel(presenter: presenter, coordinator: doubles.coordinator)
            object.viewModel = viewModel
            doubles.expectEvents([])
            return viewModel
        }(self)
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (some View, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT().environmentObject(doubles.viewModel)
        verifyMemoryLeak(for: doubles, file: file, line: line)
        return (sut, doubles)
    }
}

private extension SheetsViewTests.Doubles {
    func configureShowNewSheetScene() {
        coordinator.addNewSheetImpl = { [weak self] in
            self?.events.append("ShowAddSheet")
        }
    }
    
    func configureGetSheetsToCompleteWithEmptyState() {
        store.configureGetSheets(
            toCompleteWith: SheetStore.SheetsResult.success([]),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func configureGetSheetsUpdatableWith(list: [SheetDTO]...) {
        store.configureGetSheets(
            toCompleteWith: list.map({ .success($0) }),
            sendMessage: { [weak self] in self?.events.append($0) }
        )
    }
    
    func receiveAsyncSheetResult() {
        events = []
        store.getSheetsCompletion?()
    }
}
