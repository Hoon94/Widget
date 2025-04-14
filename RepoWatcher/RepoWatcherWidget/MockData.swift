//
//  MockData.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daehoon Lee on 4/7/25.
//

import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 65,
                                    watchers: 123,
                                    openIssues: 55,
                                    pushedAt: "2025-03-30T18:19:30Z",
                                    avatarData: Data(),
                                    contributors: [Contributor(login: "Sean Allen", avatarUrl: "", contributions: 42, avatarData: Data()),
                                                   Contributor(login: "Michael Jordan", avatarUrl: "", contributions: 23, avatarData: Data()),
                                                   Contributor(login: "Steph Curry", avatarUrl: "", contributions: 30, avatarData: Data()),
                                                   Contributor(login: "LeBron James", avatarUrl: "", contributions: 6, avatarData: Data())])
    
    static let repoOneV2 = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 112,
                                    watchers: 327,
                                    openIssues: 100,
                                    pushedAt: "2025-04-14T18:19:30Z",
                                    avatarData: Data(),
                                    contributors: [Contributor(login: "Sean Allen", avatarUrl: "", contributions: 149, avatarData: Data()),
                                                   Contributor(login: "Michael Jordan", avatarUrl: "", contributions: 50, avatarData: Data()),
                                                   Contributor(login: "Steph Curry", avatarUrl: "", contributions: 39, avatarData: Data()),
                                                   Contributor(login: "LeBron James", avatarUrl: "", contributions: 16, avatarData: Data())])
    
    static let repoTwo = Repository(name: "Repository 2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 134,
                                    watchers: 976,
                                    openIssues: 120,
                                    pushedAt: "2025-01-30T18:19:30Z",
                                    avatarData: Data())
}
