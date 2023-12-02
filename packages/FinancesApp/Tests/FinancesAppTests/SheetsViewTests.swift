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
    
    func show(sheets: SheetsViewModel) {}
    
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
        
        let presenter: SheetPresenter
        let coordinator: SheetCoordinator
        
        init(presenter: SheetPresenter, coordinator: SheetCoordinator) {
            self.presenter = presenter
            self.coordinator = coordinator
        }
        
        func setEmptyState() {
            title = "Crie sua primeira Planilha de Gastos"
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
                EmptyView()
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
        
        let text = try sut.environmentObject(doubles.viewModel)
            .inspect()
            .find(viewWithAccessibilityIdentifier: "EmptyState.Text")
            .text()
            .string()
        
        XCTAssertEqual(text, "Crie sua primeira Planilha de Gastos")
    }
    
    func testClickOnAddButton_ShouldShowAddSheet() throws {
        let (sut, doubles) = makeSut()
        doubles.configureShowNewSheetScene()
        
        try sut.environmentObject(doubles.viewModel)
            .inspect()
            .find(button: "Add Sheet")
            .tap()
            
        doubles.expectEvents(["ShowAddSheet"])
    }
    
    func testOnAppear_WhenLoadEmptyList_ShouldShowEmptyState() throws {
        let (sut, doubles) = makeSut()
        doubles.configureGetSheetsToCompleteWithEmptyState()
        try sut.inspect().group().callOnAppear()
        doubles.receiveAsyncSheetResult()
        
        let text = try sut
            .inspect()
            .find(viewWithAccessibilityIdentifier: "EmptyState.Text")
            .text()
            .string()
        
        XCTAssertEqual(text, "Crie sua primeira Planilha de Gastos")
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
    
    func receiveAsyncSheetResult() {
        events = []
        store.getSheetsCompletion?()
    }
}
