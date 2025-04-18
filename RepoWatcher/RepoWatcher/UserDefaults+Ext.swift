//
//  UserDefaults+Ext.swift
//  RepoWatcher
//
//  Created by Daehoon Lee on 4/18/25.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.io.github.hoon94.RepoWatcher") ?? UserDefaults()
    }
    
    static let repoKey = "repos"
}
