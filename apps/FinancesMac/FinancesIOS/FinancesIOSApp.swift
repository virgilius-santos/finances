import FinancesCore
import FinancesDB
import SwiftUI
import SwiftData
@testable import FinancesApp

import UniformTypeIdentifiers

@main
struct FinancesIOSApp: App {
    var body: some Scene {
//        WindowGroup.cloudApp
//        WindowGroup.expenseTracker
//        WindowGroup.wallet
//        WindowGroup.appPromo
        WindowGroup {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(0...9, id: \.self) { _ in
                        ExpenseRow.RowView(viewModel: ExpenseRow.ViewModel())
                    }
                }
            }
        }
    }
}


#Preview("light") {
    Group {
//        CloudAppView()
//        ExpenseTracker()
//        WalletView()
//        DesignCodeApp.MainView()
        AppPromo()
    }
}
