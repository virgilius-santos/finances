import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData
import FinancesApp

import UniformTypeIdentifiers

@main
struct FinancesIOSApp: App {
    var body: some Scene {
//        WindowGroup.cloudApp
//        WindowGroup.expenseTracker
//        WindowGroup.wallet
//        WindowGroup.appPromo
        WindowGroup.appPromo
    }
}


#Preview("light") {
//    CloudAppView()
//    ExpenseTracker()
//    WalletView()
//    DesignCodeApp.MainView()
    AppPromo()
}
