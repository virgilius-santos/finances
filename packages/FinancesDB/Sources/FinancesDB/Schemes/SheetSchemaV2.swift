import Foundation
import SwiftData

//extension MigrationStage {
//    static let migrateV1toV2 = MigrationStage.custom(
//        fromVersion: SheetSchemaV1.self,
//        toVersion: SheetSchemaV2.self,
//        willMigrate: { context in
//             let users = try context.fetch(FetchDescriptor<SheetSchemaV1.FinancesDBV1>())
//
//             var usedNames = Set<String>()
//
//             for user in users {
//                 if usedNames.contains(user.name) {
//                     context.delete(user)
//                 }
//
//                 usedNames.insert(user.name)
//             }
//
//             try context.save()
//        },
//        didMigrate: { context in
//            // remove duplicates then save
//        }
//    )
//}

//public enum SheetSchemaV2: VersionedSchema {
//    public static var versionIdentifier = Schema.Version(2, 0, 0)
//
//    public static var models: [any PersistentModel.Type] {
//        [FinancesDB.self]
//    }
//
//    @Model
//    public final class FinancesDBV2 {
//        public var creationDate: Date
//
//        public init(creationDate: Date = .now) {
//            self.creationDate = creationDate
//        }
//    }
//}
