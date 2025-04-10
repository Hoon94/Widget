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
                                    avatarData: Data())
    
    static let repoTwo = Repository(name: "Repository 2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 134,
                                    watchers: 976,
                                    openIssues: 120,
                                    pushedAt: "2025-01-30T18:19:30Z",
                                    avatarData: Data())
}
