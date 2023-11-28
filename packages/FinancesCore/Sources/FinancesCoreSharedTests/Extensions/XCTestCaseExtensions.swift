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
    func expect<SUT, Doubles: EventsReceiver>(
        sut: SUT,
        using doubles: Doubles,
        given: (Doubles) -> Void,
        when: (SUT, Doubles) -> Void,
        expect: [String],
        and actions: (
            when: (SUT, Doubles) -> Void,
            expect: [String]
        )...,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        given(doubles)
        
        when(sut, doubles)
        
        doubles.expectEvents(expect, file: file, line: line)
        
        for action in actions {
            action.when(sut, doubles)
            doubles.expectEvents(action.expect, file: file, line: line)
        }
    }
}
