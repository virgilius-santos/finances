import UIKit
import CoreGraphics
import CoreText
import SwiftUI

public enum FontError: Swift.Error {
    case failedToRegisterFont
}

public struct Noteworthy {
    public let name: String
    
    private init(named name: String) {
        self.name = name
        do {
            try registerFont(named: name)
        } catch {
            let reason = error.localizedDescription
            fatalError("Failed to register font: \(reason)")
        }
    }
    
    public static let bold = Noteworthy(named: "Noteworthy-Bold")
}

public extension SwiftUI.Font {
    static let appFont: SwiftUI.Font = {
        try! registerFont(named: "Noteworthy-Bold")
        return Font.custom("Noteworthy-Bold", fixedSize: 17)
    }()
    
    /// Returns a relative-size font of the specified style.
    static func relative(
        _ style: Noteworthy,
        size: CGFloat,
        relativeTo
        textStyle: Font.TextStyle
    ) -> Font {
        Font.custom(style.name, size: size, relativeTo: textStyle)
    }
}

func registerFont(named name: String) throws {
    guard
        let asset = NSDataAsset(name: "fonts/\(name)", bundle: Bundle.module),
        let provider = CGDataProvider(data: asset.data as NSData),
        let font = CGFont(provider)
    else {
        throw FontError.failedToRegisterFont
    }
    CTFontManagerRegisterGraphicsFont(font, nil)
}
