import FinancesCore
import SwiftUI

public protocol SheetCoordinator {    
    func goTo(item: SheetsViewModel.Item)
}

public struct SheetsView: View {
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        VStack {
            Button("Add Sheet") {
                viewModel.addNewSheet()
            }
            containedView()
        }
        .onAppear {
            viewModel.load()
        }
        .alert(
            isPresented: $viewModel.isAlertShowing,
            error: viewModel.error,
            actions: {
                Button("OK", action: {  viewModel.clearError() })
            }
        )
        .yearMonthPicker(
            showing: $viewModel.showYearMonthPicker,
            dateSelect: { date in viewModel.add(date: date) }
        )
    }
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    @ViewBuilder
    func containedView() -> some View {
        switch viewModel.state {
        case let .emptyState(title):
            EmptyTextView(title: title)
        case let .list(items):
            SheetsListView(
                items: items,
                selected: { item in
                    viewModel.show(item: item)
                },
                deleted: { item in
                    viewModel.delete(item: item)
                }
            )
        }
    }
}

struct SheetsListView: View {
    let items: [SheetsViewModel.Item]
    let selected: (SheetsViewModel.Item) -> Void
    let deleted: (SheetsViewModel.Item) -> Void
    
    var body: some View {
        List(items) { item in
            Text(item.title)
                .accessibilityIdentifier("\(item.id)")
                .onTapGesture {
                    selected(item)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        deleted(item)
                    }
                }
        }
        .accessibilityIdentifier("List.full")
    }
}

struct EmptyTextView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .accessibilityIdentifier("EmptyState.Text")
    }
}

extension SheetsView.ViewModel {
    enum State {
        case emptyState(title: String)
        case list(items: [SheetsViewModel.Item])
    }
}

public extension SheetsView {
    final class ViewModel: ObservableObject {
        @Published var state: State = .emptyState(title: "Crie sua primeira Planilha de Gastos")
        @Published var error: ViewModelError? {
            didSet {
                isAlertShowing = error != nil
            }
        }
        @Published var isAlertShowing = false
        @Published var showYearMonthPicker = false
        
        let presenter: SheetsPresenter
        let coordinator: SheetCoordinator
        
        public init(presenter: SheetsPresenter, coordinator: SheetCoordinator) {
            self.presenter = presenter
            self.coordinator = coordinator
        }
        
        func load() {
            presenter.load()
        }
        
        func addNewSheet() {
            showYearMonthPicker = true
//            coordinator.addNewSheet { [weak self] result in
//                if result {
//                    self?.load()
//                }
//            }
        }
        
        func add(date: Date) {
            let viewModel = AddSheetViewModel(id: .init(), date: date)
            presenter.add(sheet: viewModel)
        }
        
        func show(item: SheetsViewModel.Item) {
            coordinator.goTo(item: item)
        }
        
        func delete(item: SheetsViewModel.Item) {
            presenter.delete(item: item)
        }
        
        func clearError() {
            error = nil
        }
    }
}

extension SheetsView.ViewModel: SheetsDisplay {
    public func showEmptyData() {
        state = .emptyState(title: "Crie sua primeira Planilha de Gastos")
    }
    
    public func show(sheets: SheetsViewModel) {
        state = .list(items: sheets.items)
    }
    
    struct ViewModelError: LocalizedError {
        var errorDescription: String? = "Deu Ruim"
    }
    public func showError() {
        error = .init()
    }
}
