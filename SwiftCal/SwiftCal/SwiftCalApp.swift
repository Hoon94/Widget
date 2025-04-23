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
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Calendar", systemImage: "calendar") {
                    CalendarView()
                }
                
                Tab("Streak", systemImage: "swift") {
                    StreakView()
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
