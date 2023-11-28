import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData

@main
struct FinancesMacApp: App {
    var body: some Scene {
        DocumentGroup.init(
            editing: .financesSheets,
            migrationPlan: FinancesMigration.self,
            editor: {
                ContentView()
            },
            prepareDocument: { modelContext in
            }
        )
    }
}
