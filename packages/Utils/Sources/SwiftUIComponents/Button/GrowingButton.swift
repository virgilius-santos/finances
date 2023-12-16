import SwiftUI

public struct GrowingButton: ButtonStyle {
    public var background: Color = .blue
    
    public init(background: Color = .blue) {
        self.background = background
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 44, minHeight: 44)
            .padding()
            .background(background)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
