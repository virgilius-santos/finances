import SwiftUI
import FinancesCore

@main
struct FinancesMacApp: App {
    var body: some Scene {
        DocumentGroup(editing: Card.self, contentType: .financesSheets) {
            ContentView()
        }
    }
}

import UniformTypeIdentifiers

extension UTType {
    static let financesSheets = UTType(exportedAs: "com.versus.finances.sheets")
}


import SwiftData

@Model
final class Card {
    var front: String
    var back: String
    var creationDate: Date

    init(front: String, back: String, creationDate: Date = .now) {
        self.front = front
        self.back = back
        self.creationDate = creationDate
    }
}
