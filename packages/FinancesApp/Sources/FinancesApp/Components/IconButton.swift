import SwiftUI

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
                    .frame(minWidth: 44, minHeight: 44)
            }
        )
    }
}

