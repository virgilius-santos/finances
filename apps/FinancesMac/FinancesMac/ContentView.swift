import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var picker = true
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
