import XCTest

open class AbstractDouble: EventsReceiver {
    public let file: StaticString
    public let line: UInt
    
    public init(file: StaticString = #filePath, line: UInt = #line) {
        self.file = file
        self.line = line
    }
    
    public var events = [String]()
    
    public func cleanEvents() {
        events = []
    }
    
    public func expectEvents(_ eventsReceived: [String], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(events, eventsReceived, "invalid events received", file: file, line: line)
    }
}
