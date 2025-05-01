//
//  SingleRepoWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daehoon Lee on 4/9/25.
//

import SwiftUI
import WidgetKit

struct SingleRepoProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func snapshot(for configuration: SelectSingleRepo, in context: Context) async -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func timeline(for configuration: SelectSingleRepo, in context: Context) async -> Timeline<SingleRepoEntry> {
        let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
        
        do {
            // Get Repo
            let repoToShow = RepoURL.prefix + (configuration.repo ?? "")
            var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
            let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
            repo.avatarData = avatarImageData ?? Data()
            
            if context.family == .systemLarge {
                
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
            }
            
            // Create Entry & Timeline
            let entry = SingleRepoEntry(date: .now, repo: repo)
            
            return Timeline(entries: [entry], policy: .after(nextUpdate))
        } catch {
            print("❌ Error - \(error.localizedDescription)")
            
            return Timeline(entries: [], policy: .after(nextUpdate))
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry
    
    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
                .containerBackground(for: .widget) { }
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                
                Spacer()
                    .frame(height: 40)
                
                ContributorMediumView(repo: entry.repo)
            }
            .containerBackground(for: .widget) { }
        case .accessoryInline:
            Text("\(entry.repo.name) - \(entry.repo.daysSinceLastActivity) days")
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                Text(entry.repo.name)
                    .font(.headline)
                
                Text("\(entry.repo.daysSinceLastActivity) days")
                
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("\(entry.repo.watchers)")
                    
                    Image(systemName: "tuningfork")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("\(entry.repo.forks)")
                    
                    if entry.repo.hasIssues {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .aspectRatio(contentMode: .fit)
                        
                        Text("\(entry.repo.openIssues)")
                    }
                }
                .font(.caption)
            }
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                
                VStack {
                    Text("\(entry.repo.daysSinceLastActivity)")
                        .font(.headline)
                    
                    Text("days")
                        .font(.caption)
                }
            }
        case .systemSmall, .systemExtraLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct SingleRepoWidget: Widget {
    let kind: String = "SingleRepoWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectSingleRepo.self, provider: SingleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                SingleRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SingleRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single repository's")
        .supportedFamilies([.systemMedium,
                            .systemLarge,
                            .accessoryInline,
                            .accessoryCircular,
                            .accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    SingleRepoWidget()
} timeline: {
    SingleRepoEntry(date: .now, repo: MockData.repoOne)
    SingleRepoEntry(date: .now, repo: MockData.repoOneV2)
}
