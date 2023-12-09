import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData

import UniformTypeIdentifiers

@main
struct FinancesIOSApp: App {
    var body: some Scene {
//        DocumentGroup(editing: .itemDocument, migrationPlan: FinancesIOSMigrationPlan.self) {
//            ContentView()
//        }
//        DocumentGroup.init(
//            editing: .financesSheets,
//            migrationPlan: FinancesMigration.self,
//            editor: {
//                ContentView()
//                    .contentTransition(.identity)
//            },
//            prepareDocument: { modelContext in
//            }
//        )
        WindowGroup.expenseTracker
    }
}

//
//extension UTType {
//    static var itemDocument: UTType {
//        UTType(importedAs: "com.example.item-document")
//    }
//}
//
//struct FinancesIOSMigrationPlan: SchemaMigrationPlan {
//    static var schemas: [VersionedSchema.Type] = [
//        FinancesIOSVersionedSchema.self,
//    ]
//
//    static var stages: [MigrationStage] = [
//        // Stages of migration between VersionedSchema, if required.
//    ]
//}
//
//struct FinancesIOSVersionedSchema: VersionedSchema {
//    static var versionIdentifier = Schema.Version(1, 0, 0)
//
//    static var models: [any PersistentModel.Type] = [
//        Item.self,
//    ]
//}
