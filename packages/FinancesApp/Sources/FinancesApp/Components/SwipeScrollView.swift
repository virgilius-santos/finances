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
                        actions: [
                            SwipeAction(tint: .yellow, icon: "star.fill", isEnabled: false, action: { print("Bookmarked") }),
                            SwipeAction(tint: .blue, icon: "star.fill", action: { print("Bookmarked") }),
                            SwipeAction(tint: .red, icon: "trash.fill", action: {
                                withAnimation(.easeInOut, { colors.removeAll(where: { $0 == color })})
                            })
                        ]
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


//@resultBuilder
//struct ActionBuilder {
//    static func buildBlock(_ components: Action...) -> [Action] {
//        components
//    }
//}


typealias CustomSwipeView<T: View> = CustomSwipe.SwipeView<T>
typealias SwipeAction = CustomSwipe.Action

enum CustomSwipe {
    struct Action: Identifiable {
        var id = UUID()
        var tint: Color
        var icon: String
        var iconFont: Font = .title
        var iconTint: Color = .white
        var isEnabled = true
        var action: () -> Void
    }
    
    enum Direction {
        case leading, trailing
        
        var alignment: Alignment {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
    }
    
    struct SwipeView<Content: View>: View {
        
        var cornerRadius: CGFloat = 4
        var direction: Direction = .trailing
        
        @ViewBuilder var content: () -> Content
        
        var actions: [Action]
        
        var filteredActions: [Action] {
            actions.filter(\.isEnabled)
        }
        
        private let viewID = UUID()
        
        @Environment(\.colorScheme) var scheme
        
        @State private var isEnabled = true
        @State private var strollOffset = CGFloat.zero
        
        var body: some View {
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        content()
                            .containerRelativeFrame(.horizontal)
                            .background(scheme == .dark ? .black : .white)
                            .background {
                                if let firstAction = filteredActions.first {
                                    Rectangle()
                                        .fill(firstAction.tint)
                                        .opacity(strollOffset == .zero ? 0 : 1)
                                }
                            }
                            .id(viewID)
                            .transition(.identity)
                            .overlay {
                                GeometryReader { proxy in
                                    let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
                                    
                                    Color.clear
                                        .preference(key: OffsetKey.self, value: minX)
                                        .onPreferenceChange(OffsetKey.self) {
                                            strollOffset = $0
                                        }
                                }
                            }
                        
                        ActionButtons {
                            withAnimation(.snappy) {
                                scrollProxy.scrollTo(viewID, anchor: {
                                    switch direction {
                                    case .leading:
                                        return .topTrailing
                                    case .trailing:
                                        return .topLeading
                                    }
                                }())
                            }
                        }
                        .opacity(strollOffset == .zero ? 0 : 1)
                    }
                    .scrollTargetLayout()
                    .visualEffect { content, geometryProxy in
                        content
                            .offset(x: scrollOffset(geometryProxy))
                    }
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .background {
                    if let lastAction = filteredActions.last {
                        Rectangle()
                            .fill(lastAction.tint)
                            .opacity(strollOffset == .zero ? 0 : 1)
                    }
                }
                .clipShape(.rect(cornerRadius: cornerRadius))
            }
            .allowsHitTesting(isEnabled)
            .transition(CustomTransaction())
        }
        
        @ViewBuilder
        func ActionButtons(resetPostion: @escaping () -> Void) -> some View {
            Rectangle()
                .fill(.clear)
                .frame(width: CGFloat(filteredActions.count) * 100)
                .overlay(alignment: direction.alignment) {
                    HStack(spacing: 0, content: {
                        ForEach(filteredActions) { button in
                            Button(action: {
                                isEnabled = false
                                Task {
                                    resetPostion()
                                    try? await Task.sleep(for: .seconds(0.25))
                                    button.action()
                                    try? await Task.sleep(for: .seconds(0.25))
                                    isEnabled = true
                                }
                            }, label: {
                                Image(systemName: button.icon)
                                    .font(button.iconFont)
                                    .foregroundStyle(button.iconTint)
                                    .frame(width: 100)
                                    .frame(minHeight: 44, maxHeight: .infinity)
                                    .contentShape(.rect)
                            })
                            .buttonStyle(.plain)
                            .background(button.tint)
                        }
                    })
                }
        }
        
        func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            switch direction {
            case .leading:
                return (minX < 0) ? -minX : 0
            case .trailing:
                return (minX > 0) ? -minX : 0
            }
        }
    }
    
    struct OffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct CustomTransaction: Transition {
        func body(content: Content, phase: TransitionPhase) -> some View {
            content
                .mask {
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .offset(y: phase == .identity ? 0 : -geometry.size.height)
                    })
                }
                .containerRelativeFrame(.horizontal)
        }
    }
}


#Preview {
    SwipeScrollView()
}
