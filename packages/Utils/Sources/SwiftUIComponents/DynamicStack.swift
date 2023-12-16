import SwiftUI

public struct DynamicStack<L: View, T: View>: View {
    @ViewBuilder let leadingContent: L
    @ViewBuilder let trailingContent: T
    
    @Environment(\.sizeCategory) private var sizeCategory
    
    public var body: some View {
        if sizeCategory > .large {
            VStack(alignment: .leading, spacing: 0) {
                leadingContent
                
                trailingContent
            }
        } else {
            HStack(alignment: .center, spacing: 0) {
                leadingContent
                
                Spacer(minLength: 0)
                
                trailingContent
            }
        }
    }
    
    public init(
        @ViewBuilder leadingContent: () -> L,
        @ViewBuilder trailingContent: () -> T
    ) {
        self.leadingContent = leadingContent()
        self.trailingContent = trailingContent()
    }
}
