import SwiftUI
import SwiftUIComponents

public extension View {
    func yearMonthPicker(
        showing: Binding<Bool>,
        dateSelect: @escaping (Date) -> Void
    ) -> some View {
        modifier(Watermark(
            showing: showing,
            dateSelect: dateSelect,
            marking: { close in
                YearMonthPicker(
                    cancel: { close() },
                    dateSelected: { date in
                        dateSelect(date)
                        close()
                    }
                )
            }
        ))
    }
}

public struct YearMonthPicker: View {
    final class ViewModel: ObservableObject {
        @Published var selectedDate: Date = .now
        let months: [String] = Calendar.current.shortMonthSymbols
        
        private var calendar = Calendar.current
        private lazy var components: DateComponents = {
            calendar.dateComponents([.month, .year], from: selectedDate)
        }()
        
        func select(month: String) {
            guard let monthSelected = months.firstIndex(of: month) else {
                return
            }
            components.month = monthSelected + 1
            selectedDate = calendar.date(from: components)!
        }
        
        func increaseYear() {
            components.year! += 1
            selectedDate = calendar.date(from: components)!
        }
        
        func decreaseYear() {
            components.year! -= 1
            selectedDate = calendar.date(from: components)!
        }
    }
    
    @StateObject private var viewModel = ViewModel()
    @State private var sheetHeight: CGFloat = .zero
    
    var cancel: () -> Void
    var dateSelected: (Date) -> Void
    
    public init(cancel: @escaping () -> Void, dateSelected: @escaping (Date) -> Void) {
        self.cancel = cancel
        self.dateSelected = dateSelected
    }
    
    public var body: some View {
        VStack {
            YearPicker(
                selectedDate: $viewModel.selectedDate,
                increase: viewModel.increaseYear,
                decrease: viewModel.decreaseYear
            )
            
            MonthGrid(selectedDate: $viewModel.selectedDate, selectMonth: viewModel.select(month:))
            
            HStack {
                Spacer()
                
                Button("Done") { dateSelected(viewModel.selectedDate) }
                    .buttonStyle(GrowingButton())
                
                Button("Cancel", action: cancel)
                    .buttonStyle(GrowingButton(background: .red))
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .padding()
        .border(Color.black)
        .padding()
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()+24
    }
}
