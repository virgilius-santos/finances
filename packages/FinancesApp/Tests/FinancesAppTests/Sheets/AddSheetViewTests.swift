import XCTest
import FinancesCore
import FinancesApp
import FinancesCoreSharedTests
import ViewInspector
import SwiftUI

public struct AddSheetView: View {
    //@Binding var date: Date
    
    enum Planet: String, CaseIterable, Identifiable {
            case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
            var id: Self { self }
        }
        @State private var selectedPlanet: Planet = .earth
    
    public var body: some View {
        Picker("year", selection: $selectedPlanet) {
            ForEach(Planet.allCases) { planet in
                Text(planet.rawValue.capitalized)
            }
        }
    }
}

final class AddSheetViewTests: XCTestCase {
    func testOnAppear_ShouldDisplayCurrentDate() throws {
        let (sut, doubles) = makeSut()
        
        let datePicker = try sut.inspect().datePicker()
    }
}

private extension AddSheetViewTests {
    typealias SUT = AddSheetView
    
    final class Doubles: AbstractDouble {
        
    }
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (SUT, Doubles) {
        let doubles = Doubles(file: file, line: line)
        let sut = SUT()
        verifyMemoryLeak(for: doubles, file: file, line: line)
        return (sut, doubles)
    }
}
