//
//  Persistence.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/22/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let databaseName = "SwiftCal.sqlite"
    
    var oldStoredURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appending(path: databaseName)
        // return .applicationSupportDirectory.appending(path: databaseName)
    }
    
    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.hoon94.SwiftCal")!
        return container.appending(path: databaseName)
    }

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now
        
        for dayOffset in 0..<30 {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate) ?? .now
            let didStudy = Bool.random()
            let newDay = Day(date: date, didStudy: didStudy)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftCal")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else if !FileManager.default.fileExists(atPath: oldStoredURL.path(percentEncoded: false)) {
            print("🎅🏻 Old store doesn't exist. Using new shared URL")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        
        print("🕸️ container URL = \(container.persistentStoreDescriptions.first!.url!)")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        print("➡️ went into migrateStore")
        let coordinator = container.persistentStoreCoordinator
        
        guard let oldStore = coordinator.persistentStore(for: oldStoredURL) else { return }
        print("🛡️ Old Store no longer exists")
        
        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("🏁 Migration successful")
        } catch {
            fatalError("Unable to migrate to shared store")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoredURL)
            print("🗑️ Old Store deleted")
        } catch {
            print("Unable to delete oldStore")
        }
    }
}
