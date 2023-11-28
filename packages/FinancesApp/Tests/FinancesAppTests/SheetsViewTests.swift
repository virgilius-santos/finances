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
    
    final class Doubles: AbstractDouble {
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT()
        verifyMemoryLeak(for: doubles, file: file, line: line)
        return (sut, doubles)
    }
}
