import SwiftUI

public extension IconButton {
    static func addButton(action: @escaping () -> Void) -> some View {
        IconButton(imageName: "plus.circle.fill", action: action)
    }
}

public struct IconButton: View {
    let imageName: String
    let action: () -> Void
    
    public init(imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    public var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: imageName)
                    .font(.title3)
                    .frame(minWidth: 44, minHeight: 44)
            }
        )
    }
}

