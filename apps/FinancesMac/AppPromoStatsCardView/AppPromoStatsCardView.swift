import WidgetKit
import SwiftData
import SwiftUI
import AppPromo

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []

        entries.append(.init(date: .now))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
}

struct AppPromoStatsCardViewEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            AppPromo.Widget()
        }
    }
}

struct AppPromoStatsCardView: Widget {
    let kind: String = "AppPromoStatsCardView"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppPromoStatsCardViewEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("AppPromo Kavsoft")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    AppPromoStatsCardView()
} timeline: {
    WidgetEntry(date: .now)
}
