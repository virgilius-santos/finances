import SwiftUI

public struct MonthGrid: View {
    
    @Binding var selectedDate: Date
    var selectMonth: (String) -> Void
    
    let months: [String] = Calendar.current.shortMonthSymbols
    let columns = [ GridItem(.adaptive(minimum: 80)) ]
    
    public init(selectedDate: Binding<Date>, selectMonth: @escaping (String) -> Void) {
        _selectedDate = selectedDate
        self.selectMonth = selectMonth
    }
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(months, id: \.self) { month in
                Button(
                    action: { selectMonth(month) },
                    label: {
                        Text(month)
                            .foregroundColor(Color.green)
                            .font(.headline)
                            .frame(width: 60, height: 44)
                            .bold()
                            .background(isSelected(month: month) ? Color.black : Color.orange)
                            .cornerRadius(8)
                    }
                )
            }
        }
        .padding(.horizontal)
    }
    
    func isSelected(month: String) -> Bool {
        month == selectedDate.formatted(.dateTime.month(.abbreviated))
    }
}
