//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Daehoon Lee on 3/18/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        // Generate a timeline consisting of seven entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct MonthlyWidgetEntryView : View {
    var entry: DayEntry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(.gray.gradient)
            
            VStack {
                HStack(spacing: 4) {
                    Text("⛄️")
                        .font(.title)
                    
                    Text(entry.date.weekdayDisplayFormat)
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(.black.opacity(0.6))
                    
                    Spacer()
                }
                
                Text(entry.date.dayDisplayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
        }
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MonthlyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DayEntry(date: .now, emoji: "😀")
    DayEntry(date: .now, emoji: "🤩")
}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
