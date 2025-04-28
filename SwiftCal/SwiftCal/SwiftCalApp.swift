//
//  SwiftCalApp.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/22/25.
//

import SwiftData
import SwiftUI

@main
struct SwiftCalApp: App {
    @State private var selectedTab = 0
    
    static var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.hoon94.SwiftCal")!
        return container.appending(path: "SwiftCal.sqlite")
    }
    
    let container: ModelContainer = {
        let config = ModelConfiguration(url: sharedStoreURL)
        return try! ModelContainer(for: Day.self, configurations: config)
    }()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(0)
                
                StreakView()
                    .tabItem {
                        Label("Streak", systemImage: "swift")
                    }
                    .tag(1)
                
//                Tab("Calendar", systemImage: "calendar") {
//                    CalendarView()
//                }
//                
//                Tab("Streak", systemImage: "swift") {
//                    StreakView()
//                }
            }
            .modelContainer(container)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
