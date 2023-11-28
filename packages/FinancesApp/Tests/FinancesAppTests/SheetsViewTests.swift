import XCTest
import FinancesApp
import FinancesCore
import FinancesCoreSharedTests

import SwiftUI

struct SheetsView {
}

final class SheetsViewTests: XCTestCase {
    func test() {
    }
}

private extension SheetsViewTests {
    typealias SUT = SheetsView
    
    final class Doubles: EventsReceiver {
        let file: StaticString
        let line: UInt
        
        init(file: StaticString = #filePath, line: UInt = #line) {
            self.file = file
            self.line = line
        }
        
        var events = [String]()
        
        func expectEvents(_ eventsReceived: [String], file: StaticString = #filePath, line: UInt = #line) {
            XCTAssertEqual(events, eventsReceived, "invalid events received", file: file, line: line)
        }
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT()
        verifyMemoryLeak(for: doubles, file: file, line: line)
        return (sut, doubles)
    }
}
