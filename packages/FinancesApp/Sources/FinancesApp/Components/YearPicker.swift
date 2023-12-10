import SwiftUI

public struct YearPicker: View {
    @Binding var selectedDate: Date
    var increase: () -> Void
    var decrease: () -> Void
    
    public init(selectedDate: Binding<Date>, increase: @escaping () -> Void, decrease: @escaping () -> Void) {
        _selectedDate = selectedDate
        self.increase = increase
        self.decrease = decrease
    }
    
    public var body: some View {
        HStack {
            IconButton.backButton(action: decrease)
            
            Text(selectedDate.formatted(.dateTime.year()))
                .fontWeight(.bold)
                .transition(.move(edge: .trailing))
            
            IconButton(imageName: "chevron.right", action: increase)
        }
        .padding(15)
    }
}
