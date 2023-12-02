import SwiftUI
import ViewInspector
import XCTest

extension View {
    func tap(onLabel value: String) throws {
        try inspect()
            .find(button: "Add Sheet")
            .tap()
    }
    
    func tap(onID id: String) throws {
        try inspect()
            .find(viewWithAccessibilityIdentifier: id)
            .callOnTapGesture()
    }
    
    func findValue(for id: String) throws -> String {
        try inspect()
        .find(viewWithAccessibilityIdentifier: "EmptyState.Text")
        .text()
        .string()
    }
    
    func getListRowsIds(numberOfRows: Int, file: StaticString = #filePath, line: UInt = #line) throws -> [String] {
        var rowsIds = [String]()
        let list = try inspect()
            .find(viewWithAccessibilityIdentifier: "List.full")
            .list()
        for i in 0..<numberOfRows {
            try rowsIds.append(list.forEach(0).text(i).string())
        }
        XCTAssertThrowsError(try list.forEach(0).text(numberOfRows), "invalid number of elements", file: file, line: line)
        return rowsIds
    }
    
    func callOnAppear() throws {
        try inspect().group().callOnAppear()
    }
}
