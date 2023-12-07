import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var coordinator = AppCoordinator()
    
    @State private var presentedNumbers = [1, 4, 8]
    var body: some View {
        VStack {
//            SheetsView(modelContext: modelContext, coordinator: coordinator)
            NavigationStack(path: $presentedNumbers) {
                List(1..<50) { i in
                    NavigationLink(value: i) {
                        Label("Row \(i)", systemImage: "\(i).circle")
                    }
                }
                .navigationDestination(for: Int.self) { i in
                    Text("Detail \(i)")
                }
                .navigationTitle("Navigation")
            }
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
