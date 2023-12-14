import SwiftUI

public struct Watermark<V: View>: ViewModifier {
    public typealias CloseAction = () -> Void
    
    @Binding var showing: Bool
    
    let dateSelect: (Date) -> Void
    let marking: (@escaping CloseAction) -> V
    
    public init(
        showing: Binding<Bool>,
        dateSelect: @escaping (Date) -> Void,
        marking: @escaping (@escaping CloseAction) -> V
    ) {
        _showing = showing
        self.dateSelect = dateSelect
        self.marking = marking
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .opacity(showing ? 0.3 : 1)
            if showing {
                marking {
                    showing = false
                }
            }
        }
    }
}
