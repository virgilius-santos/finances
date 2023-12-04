import XCTest

public extension XCTestCase {
    func verifyMemoryLeak(for object: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [ weak object] in
            XCTAssertNil(object, "verify potential leak", file: file, line: line)
        }
    }
}

public protocol EventsReceiver {
    func expectEvents(_ eventsReceived: [String], file: StaticString, line: UInt)
}

public extension XCTestCase {  
    struct Step<SUT, Doubles> {
        fileprivate let when: (SUT, Doubles) throws -> Void
        fileprivate let then: () throws -> Void
        fileprivate let eventsExpected: [String]
        fileprivate let file: StaticString
        fileprivate let line: UInt
        
        public static func Step<Result>(
            when: @escaping (SUT, Doubles) throws -> Result,
            then: @escaping (Result) throws -> Void = { _ in },
            eventsExpected: [String] = [],
            file: StaticString = #filePath, line: UInt = #line
        ) -> Step<SUT, Doubles> {
            .init(when: when, then: then, eventsExpected: eventsExpected, file: file, line: line)
        }
        
        public static func And<Result>(
            when: @escaping (SUT, Doubles) throws -> Result,
            then: @escaping (Result) throws -> Void = { _ in },
            eventsExpected: [String] = [],
            file: StaticString = #filePath, line: UInt = #line
        ) -> Step<SUT, Doubles> {
            .init(when: when, then: then, eventsExpected: eventsExpected, file: file, line: line)
        }
        
        fileprivate init<Result>(
            when: @escaping (SUT, Doubles) throws -> Result,
            then: @escaping (Result) throws -> Void = { _ in },
            eventsExpected: [String] = [],
            file: StaticString = #filePath, line: UInt = #line
        ) {
            var result: Result!
            self.when = { result = try when($0, $1) }
            self.then = { try then(result) }
            self.eventsExpected = eventsExpected
            self.file = file
            self.line = line
        }
    }
    
    func expect<SUT, Doubles: EventsReceiver>(
        sut: SUT,
        using doubles: Doubles,
        given: (Doubles) -> Void = { _ in },
        _ firstStep: Step<SUT, Doubles>,
        _ moreSteps: Step<SUT, Doubles>...
    ) throws {
        given(doubles)
        
        for step in ([firstStep] + moreSteps) {
            try step.when(sut, doubles)
            try step.then()
            doubles.expectEvents(step.eventsExpected, file: step.file, line: step.line)
        }
    }
}
