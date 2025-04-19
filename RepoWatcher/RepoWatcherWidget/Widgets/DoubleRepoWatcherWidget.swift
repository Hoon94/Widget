//
//  DoubleRepoWatcherWidget.swift
//  DoubleRepoWatcherWidget
//
//  Created by Daehoon Lee on 3/30/25.
//

import SwiftUI
import WidgetKit

struct DoubleRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (DoubleRepoEntry) -> ()) {
        let entry = DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Top Repo
                var topRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.publish)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: topRepo.owner.avatarUrl)
                topRepo.avatarData = topAvatarImageData ?? Data()
                
                // Get Bottom Repo
                var bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.google)
                let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()
                
                // Create Entry & Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: topRepo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository
}

struct DoubleRepoWatcherWidgetEntryView : View {
    var entry: DoubleRepoEntry
    
    var body: some View {
        VStack(spacing: 76) {
            RepoMediumView(repo: entry.topRepo)
            RepoMediumView(repo: entry.bottomRepo)
        }
        .containerBackground(for: .widget) { }
    }
}

struct DoubleRepoWatcherWidget: Widget {
    let kind: String = "DoubleRepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DoubleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                DoubleRepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DoubleRepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on two GitHub repositories.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    DoubleRepoWatcherWidget()
} timeline: {
    DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    DoubleRepoEntry(date: Date(), topRepo: MockData.repoOneV2, bottomRepo: MockData.repoTwo)
}
