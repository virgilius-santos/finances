import SwiftUI

struct SwipeScrollView: View {
    @State var colors: [Color] = [.blue, .yellow, .black, .purple, .brown]
    
    var body: some View {
        NavigationStack {
            CustomScrollView {
                ForEach(colors, id: \.self) { color in
                    CustomSwipeView(
                        cornerRadius: 8,
                        content: {
                            CardView(color)
                        },
                        actions: {
                            SwipeAction(tint: .yellow, icon: "star.fill", isEnabled: false, action: { print("Bookmarked") })
                         
                            SwipeAction(tint: .blue, icon: "star.fill", action: { print("Bookmarked") })
                            
                            SwipeAction(tint: .red, icon: "trash.fill", action: {
                                withAnimation(.easeInOut, { colors.removeAll(where: { $0 == color })})
                            })
                        }
                    )
                }
            }
            .navigationTitle("Messages")
        }
    }
}

extension SwipeScrollView {
    @ViewBuilder
    func CustomScrollView(@ViewBuilder content: () -> some View) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                content()
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 16)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func CardView(_ color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 52, height: 52)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 80, height: 5)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 60, height: 5)
            }
            
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white.opacity(0.4))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(color.gradient)
    }
}
