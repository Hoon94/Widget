//
//  SwiftCalApp.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/22/25.
//

import SwiftUI

@main
struct SwiftCalApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedTab = 0
    
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
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
