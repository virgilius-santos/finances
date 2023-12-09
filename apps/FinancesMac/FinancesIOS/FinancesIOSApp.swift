import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData
import FinancesApp

import UniformTypeIdentifiers

@main
struct FinancesIOSApp: App {
    var body: some Scene {
        WindowGroup.expenseTracker
    }
}

#Preview {
    ExpenseTracker()
}
