import Foundation
import FinancesCore
import FinancesApp

final class AppCoordinator: ObservableObject { 
    @Published var presentedNumbers: [Int] = []
}

extension AppCoordinator: SheetCoordinator {
    func goTo(item: SheetsViewModel.Item) {
        presentedNumbers = [1]
    }
}
