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

extension Image {
    static var pic: some View {
        WalletImage(
            named: "pic",
            contentMode: .fill,
            size: .init(width: 50, height: 50)
        )
    }
    
    static var sim: some View {
        WalletImage(
            named: "sim",
            contentMode: .fit,
            size: .init(width: 55, height: 55)
        )
    }
    
    static var dropbox: some View {
        WalletImage(
            named: "dropbox",
            contentMode: .fit,
            size: .init(width: 45, height: 45)
        )
    }
    
    static var drive: some View {
        WalletImage(
            named: "drive",
            contentMode: .fit,
            size: .init(width: 45, height: 45)
        )
    }
    
    static var icloud: some View {
        WalletImage(
            named: "icloud",
            contentMode: .fit,
            size: .init(width: 45, height: 45)
        )
    }
    
    static func makePic(_ index: Int) -> some View {
        WalletImage(
            named: "pic\(index)",
            contentMode: .fill,
            size: .init(width: 50, height: 50)
        )
    }
}
