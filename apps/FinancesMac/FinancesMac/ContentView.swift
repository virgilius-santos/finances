import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            SheetsView(modelContext: modelContext)
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

