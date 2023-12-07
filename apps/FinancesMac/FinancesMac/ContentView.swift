import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var coordinator = AppCoordinator()
    
    @State var picker = true
    var body: some View {
        VStack {
            SheetsView(modelContext: modelContext, coordinator: coordinator)
        }
    }
}

#if DEBUG
#Preview {
    ContentView()
        .configPreview()
}
#endif

import SwiftData

protocol AddStore {
    func addNewSheet()
}
