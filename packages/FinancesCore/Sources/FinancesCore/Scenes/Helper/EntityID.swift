import Foundation

public struct EntityID<T>: Codable, Hashable, CustomStringConvertible {
    public var description: String { value.uuidString }
    
    public let value: UUID
    
    public init(_ value: UUID = .init()) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(UUID.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
