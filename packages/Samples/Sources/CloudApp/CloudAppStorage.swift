import SwiftUI

struct CloudAppStorage<I: View>: View {
    var image: I
    var title: String
    var capacity: String
    var percentage: CGFloat
    
    var body: some View {
        VStack(alignment: isMacOS ? .leading : .center, spacing: 8) {
            HStack {
                image // Image.dropbox
                
                Divider()
                    .frame(height: 45)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: percentage)
                        .stroke(Color.blueApp, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    Text("\(Int(percentage * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
                .frame(width: 50, height: 50)
            }
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(.top)
            
            Text(capacity)
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
    }
}
