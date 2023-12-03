import FinancesCore
import SwiftUI

public protocol SheetCoordinator {
    typealias NewSheetResult = Bool
    func addNewSheet(completion: @escaping (NewSheetResult) -> Void)
    
    func goTo(item: SheetsViewModel.Item)
}

public struct SheetsView: View {
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        Group {
            Button("Add Sheet") {
                viewModel.addNewSheet()
            }
            containedView()
        }
        .onAppear {
            viewModel.load()
        }
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
            SheetsListView(items: items, selected: { item in
                viewModel.show(item: item)
            })
        }
    }
}

struct SheetsListView: View {
    let items: [SheetsViewModel.Item]
    let selected: (SheetsViewModel.Item) -> Void
    
    var body: some View {
        List(items) { item in
            Text(item.id.value.uuidString)
                .accessibilityIdentifier("\(item.id)")
                .onTapGesture {
                    selected(item)
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
        
        let presenter: SheetPresenter
        let coordinator: SheetCoordinator
        
        public init(presenter: SheetPresenter, coordinator: SheetCoordinator) {
            self.presenter = presenter
            self.coordinator = coordinator
        }
        
        func load() {
            presenter.load()
        }
        
        func addNewSheet() {
            coordinator.addNewSheet { [weak self] result in
                if result {
                    self?.load()
                }
            }
        }
        
        func show(item: SheetsViewModel.Item) {
            coordinator.goTo(item: item)
        }
    }
}

extension SheetsView.ViewModel: SheetDisplay {
    public func showEmptyData() {
        state = .emptyState(title: "Crie sua primeira Planilha de Gastos")
    }
    
    public func show(sheets: SheetsViewModel) {
        state = .list(items: sheets.items)
    }
    
    public func showError() {
        // TODO: pending
    }
}
