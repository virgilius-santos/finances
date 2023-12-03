import Foundation
import SwiftData

public enum SheetSchemaV1: VersionedSchema {
    public static var versionIdentifier = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [FinancesDBV1.self]
    }
    
    @Model
    public final class FinancesDBV1 {
        public var id: UUID
        public var creationDate: Date
        
        public init(creationDate: Date = .now, id: UUID = .init()) {
            self.creationDate = creationDate
            self.id = id
        }
    }
}
