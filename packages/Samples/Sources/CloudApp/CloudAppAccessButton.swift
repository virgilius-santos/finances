import SwiftUI

struct CloudAppAccessButton: View {
    let image: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            VStack(spacing: 12) {
                Image(systemName: image)
                    .font(.title)
                    .foregroundStyle(color)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .kerning(1.3)
                    .foregroundStyle(Color.black)
                
            }
            .frame(minWidth: 80)
        })
    }
}
