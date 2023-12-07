import SwiftData

#if DEBUG
@MainActor
public let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: FinancesDB.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<FinancesDB>()).isEmpty {
            SampleDeck.contents.forEach { container.mainContext.insert($0) }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

enum SampleDeck {
    static let contents: [FinancesDB] = [
        .init(),
        .init()
    ]
}
#endif
