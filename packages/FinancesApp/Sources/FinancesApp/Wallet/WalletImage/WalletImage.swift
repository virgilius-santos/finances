import SwiftUI

private func _WalletImage(named name: String) -> Image {
    guard let uiImage = UIImage(with: name) else {
        return Image(systemName: "person")
    }
    return Image(uiImage: uiImage)
}

func WalletImage(
    named name: String,
    contentMode: ContentMode,
    size: CGSize
) -> some View {
    _WalletImage(named: name)
        .resizable()
        .aspectRatio(contentMode: contentMode)
        .frame(width: size.width, height: size.height)
}

func WalletPNG(
    named name: String,
    contentMode: ContentMode,
    size: CGSize
) -> some View {
    _WalletImage(named: name)
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: contentMode)
        .frame(width: size.width, height: size.height)
}

extension UIImage {
    convenience init?(with name: String) {
        self.init(named: name, in: Bundle.module, compatibleWith: nil)
    }
}
