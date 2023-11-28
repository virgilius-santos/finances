import XCTest

extension UUID {
    static func fixture(uuidString: String = "912d2f74-8bd6-4706-bb49-9802b61bef13") -> Self {
        guard let uuid = UUID(uuidString: uuidString) else {
            XCTFail("invalid uuid received. \(uuidString)")
            return .init()
        }
        return uuid
    }
}
