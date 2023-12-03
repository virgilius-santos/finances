import XCTest

public extension Date {
    static func fixture() -> Self {
        Date(timeIntervalSince1970: 2000)
    }
}
