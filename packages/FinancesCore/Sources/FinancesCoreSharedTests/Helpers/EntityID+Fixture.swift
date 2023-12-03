import FinancesCore
import Foundation

public extension EntityID {
    static func fixture(id: UUID = .fixture()) -> EntityID<T> {
        .init(id)
    }
}
