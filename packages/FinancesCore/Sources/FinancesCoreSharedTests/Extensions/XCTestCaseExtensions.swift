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
        
        public init<Result>(
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
        when: @escaping (SUT, Doubles) throws -> Void,
        expectEvents: [String],
        and actions: (
            when: (SUT, Doubles) -> Void,
            expectEvents: [String]
        )...,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        try expect(
            sut: sut,
            using: doubles,
            given: given,
            step: .init(
                when: { try when($0, $1) },
                then: { _ in },
                eventsExpected: expectEvents,
                file: file, line: line
            ),
            and: actions.map { step in .init(
                when: { step.when($0, $1) },
                eventsExpected: step.expectEvents,
                file: file, line: line
            )}
        )
    }
    
    func expect<SUT, Doubles: EventsReceiver>(
        sut: SUT,
        using doubles: Doubles,
        given: (Doubles) -> Void = { _ in },
        step firstStep: Step<SUT, Doubles>,
        and moreSteps: [Step<SUT, Doubles>]
    ) throws {
        given(doubles)
        
        for step in ([firstStep] + moreSteps) {
            try step.when(sut, doubles)
            try step.then()
            doubles.expectEvents(step.eventsExpected, file: step.file, line: step.line)
        }
    }
    
    func expect<SUT, Doubles: EventsReceiver>(
        sut: SUT,
        using doubles: Doubles,
        given: (Doubles) -> Void = { _ in },
        step firstStep: Step<SUT, Doubles>,
        _ moreSteps: Step<SUT, Doubles>...
    ) throws {
       try expect(sut: sut, using: doubles, given: given, step: firstStep, and: moreSteps)
    }
}
