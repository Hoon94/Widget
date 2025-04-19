//
//  RepoMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daehoon Lee on 4/4/25.
//

import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter()
    var daysSinceLastActivity: Int {
        calculateDaysSinceLastActivity(from: repo.pushedAt)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if #available(iOS 18.0, *) {
                        Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(resource: .avatar))
                            .resizable()
                            .widgetAccentedRenderingMode(.desaturated)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(resource: .avatar))
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    Text(repo.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .widgetAccentable()
                }
                .padding(.bottom, 6)
                
                HStack {
                    StatLabel(value: repo.watchers, systemImageName: "star.fill")
                    StatLabel(value: repo.forks, systemImageName: "tuningfork")
                    if repo.hasIssues {
                        StatLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(daysSinceLastActivity)")
                    .bold()
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(daysSinceLastActivity > 50 ? .pink : .green)
                    .contentTransition(.numericText())
                    .widgetAccentable()
                
                Text("days ago")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .containerBackground(for: .widget) { }
    }
    
    private func calculateDaysSinceLastActivity(from dateString: String) -> Int {
        let lastActivityDate = formatter.date(from: dateString) ?? .now
        let daysSinceLastActivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
        
        return daysSinceLastActivity
    }
}

#Preview(as: .systemLarge) {
    DoubleRepoWatcherWidget()
} timeline: {
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOneV2, bottomRepo: MockData.repoTwo)
}

private struct StatLabel: View {
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .contentTransition(.numericText())
                .widgetAccentable()
        } icon: {
            Image(systemName: systemImageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}
