import SwiftData
import Foundation

public typealias FinancesDB = SheetSchemaV1.FinancesDBV1

public enum FinancesMigration: SchemaMigrationPlan {
    public static var schemas: [VersionedSchema.Type] = [
        SheetSchemaV1.self,
//        SheetSchemaV2.self
    ]
    
    
    public static var stages: [MigrationStage] = [
//        .migrateV1toV2,
    ]
}
