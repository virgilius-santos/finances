import SwiftUI

struct CloudAppSideView: View {
    var body: some View {
        VStack(alignment: isMacOS ? .leading : .center) {
            
            Text("Storage")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            
            
            // Storage space
            VStack {
                ZStack {
                    
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 24)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.blueApp, style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text("70%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        
                        Text("Used")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                }
                .frame(width: 130, height: 170)
                
                HStack(spacing: 16) {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total Space")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Text("256 GB")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("Used Space")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Text("128 GB")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
        }
        .frame(width: isMacOS ? 200 : nil)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.grayApp.ignoresSafeArea())
    }
}
