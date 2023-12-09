import SwiftUI
import FinancesApp
import FinancesCore
import FinancesDB

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
//    @StateObject var coordinator = AppCoordinator()
    
    var body: some View {
//        VStack {
//        NavigationStack(path: $coordinator.presentedNumbers) {
//            SheetsView(modelContext: modelContext, coordinator: coordinator)
//                .navigationDestination(for: Int.self) { i in
//                    Text("Detail \(i)")
//                }
//                .navigationTitle("Navigation")
//        }
        EmptyView()
    }
}

#if DEBUG
#Preview {
    ContentView()
        .configPreview()
}
#endif
