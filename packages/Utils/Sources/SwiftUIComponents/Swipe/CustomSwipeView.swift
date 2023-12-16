import SwiftUI

public typealias CustomSwipeView<T: View> = CustomSwipe.SwipeView<T>
public typealias SwipeAction = CustomSwipe.Action

@resultBuilder
public struct ActionBuilder {
    public static func buildBlock(_ components: SwipeAction...) -> [SwipeAction] {
        components
    }
}

public enum CustomSwipe {
    public struct Action: Identifiable {
        public var id = UUID()
        var tint: Color
        var icon: String
        var iconFont: Font = .title
        var iconTint: Color = .white
        var isEnabled = true
        var action: () -> Void
        
        public init(
            id: UUID = UUID(),
            tint: Color,
            icon: String,
            iconFont: Font = .title,
            iconTint: Color = .white,
            isEnabled: Bool = true,
            action: @escaping () -> Void
        ) {
            self.id = id
            self.tint = tint
            self.icon = icon
            self.iconFont = iconFont
            self.iconTint = iconTint
            self.isEnabled = isEnabled
            self.action = action
        }
    }
    
    public enum Direction {
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
    
    public struct SwipeView<Content: View>: View {
        
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
        
        public init(
            cornerRadius: CGFloat = 4,
            direction: Direction = .trailing,
            @ViewBuilder content: @escaping () -> Content,
            @ActionBuilder actions: () -> [Action]
        ) {
            self.cornerRadius = cornerRadius
            self.direction = direction
            self.content = content
            self.actions = actions()
        }
        
        public var body: some View {
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
                            .frame(width: geometry.size.width+12, height: geometry.size.height+12)
                            .offset(.init(width: -6, height: -4))
                            .offset(y: phase == .identity ? 0 : -geometry.size.height)
                    })
                }
                .containerRelativeFrame(.horizontal)
        }
    }
}
