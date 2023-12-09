import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData

@main
struct FinancesMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FinancesDB.self)
        DocumentGroup.init(
            editing: .financesSheets,
            migrationPlan: FinancesMigration.self,
            editor: {
                ContentView()
                    .contentTransition(.identity)
            },
            prepareDocument: { modelContext in
            }
        )
        
    }
}
