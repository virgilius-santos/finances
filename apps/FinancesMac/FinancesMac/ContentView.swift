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
            Button("text") {
                picker = true
            }
            .frame(minWidth: 44, minHeight: 44)
        }
        .watermarked(showing: $picker)
    }
}

extension View {
    func watermarked(showing: Binding<Bool>) -> some View {
        modifier(Watermark(showing: showing))
    }
}

struct Watermark: ViewModifier {
    @Binding var showing: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
            if showing {
                YearMonthPicker(
                    cancel: { showing = false },
                    dateSelected: { date in showing = false}
                )
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
