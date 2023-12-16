import Foundation

struct Category: Equatable, Hashable, Identifiable {
    var id: UUID = .init()
    var name: String
}
