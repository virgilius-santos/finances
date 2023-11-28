import FinancesDB
import SwiftUI

#if DEBUG
extension View {
    @MainActor 
    func configPreview() -> some View {
        modelContainer(previewContainer)
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 500)
        #endif
    }
}
#endif
