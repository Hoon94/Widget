//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daehoon Lee on 4/9/25.
//

import SwiftUI
import WidgetKit

struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<ContributorEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Repo
                let repoToShow = RepoURL.swiftNews
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                
                // Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                // Filter to just the top 4
                var topFour = Array(contributors.prefix(4))
                
                // Download top four avatars
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
                
                // Create Entry & Timeline
                let entry = ContributorEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct ContributorEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct ContributorEntryView : View {
    var entry: ContributorEntry
    
    var body: some View {
        VStack {
            RepoMediumView(repo: entry.repo)
            
            ContributorMediumView(repo: entry.repo)
        }
    }
}

struct ContributorWidget: Widget {
    let kind: String = "ContributorWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            if #available(iOS 17.0, *) {
                ContributorEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ContributorEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Contributors")
        .description("Keep track of a repository's top contributors.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    ContributorWidget()
} timeline: {
    ContributorEntry(date: .now, repo: MockData.repoOne)
}
