import SwiftUI

struct CloudAppCustomSearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            Button(action: {}, label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background(Color.blueApp)
            })
        }
        .padding(.leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
    }
}
