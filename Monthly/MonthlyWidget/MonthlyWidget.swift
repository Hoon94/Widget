//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Daehoon Lee on 3/18/25.
//

import AppIntents
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), showFunFont: false)
    }
    
    func snapshot(for configuration: ChangeFontIntent, in context: Context) async -> DayEntry {
        return DayEntry(date: Date(), showFunFont: false)
    }
    
    func timeline(for configuration: ChangeFontIntent, in context: Context) async -> Timeline<DayEntry> {
        var entries: [DayEntry] = []
        
        let showFunFont = configuration.funFont ?? false
        
        // Generate a timeline consisting of seven entries a day apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate, showFunFont: showFunFont)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    let showFunFont: Bool
}

struct MonthlyWidgetEntryView : View {
    @Environment(\.showsWidgetContainerBackground) var showsBackground
    var entry: DayEntry
    var config: MonthConfig
    let funFontName = "Chalkduster"
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text(config.emojiText)
                    .font(.title)
                    .background(Color.black)
                    .compositingGroup()
                    .luminanceToAlpha()
                    .widgetAccentable()
                
                Text(entry.date.weekdayDisplayFormat)
                    .font(entry.showFunFont ? .custom(funFontName, size: 24) : .title3)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    .foregroundStyle(showsBackground ? config.weekdayTextColor : .white)
                
                Spacer()
            }
            .id(entry.date)
            .transition(.push(from: .trailing))
            .animation(.bouncy, value: entry.date)
            
            Text(entry.date.dayDisplayFormat)
                .font(entry.showFunFont ? .custom(funFontName, size: 80) : .system(size: 80, weight: .heavy))
                .foregroundStyle(showsBackground ? config.dayTextColor : .white)
                .contentTransition(.numericText())
                .widgetAccentable()
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
        }
    }
}

struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ChangeFontIntent.self, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonthlyWidgetEntryView(entry: entry)
//                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MonthlyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month.")
        .supportedFamilies([.systemSmall])
        .disfavoredLocations([.standBy], for: [.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    MockData.dayOne
    MockData.dayTwo
    MockData.dayThree
    MockData.dayFour
}

struct ChangeFontIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Fun Font"
    static var description: IntentDescription = .init(stringLiteral: "Switch to a fun font")
    
    @Parameter(title: "Fun Font")
    var funFont: Bool?
}

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}

struct MockData {
    static let dayOne = DayEntry(date: dateToDisplay(month: 11, day: 4), showFunFont: false)
    static let dayTwo = DayEntry(date: dateToDisplay(month: 11, day: 5), showFunFont: true)
    static let dayThree = DayEntry(date: dateToDisplay(month: 11, day: 6), showFunFont: false)
    static let dayFour = DayEntry(date: dateToDisplay(month: 11, day: 7), showFunFont: false)
    
    static func dateToDisplay(month: Int, day: Int) -> Date {
        let components = DateComponents(calendar: Calendar.current,
                                        year: 2025,
                                        month: month,
                                        day: day)
        
        return Calendar.current.date(from: components)!
    }
}
