//
//  AppIntents.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/29/25.
//

import AppIntents
import Foundation
import SwiftData
import WidgetKit

struct ToggleStudyIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Studied"
    
    @Parameter(title: "Date")
    private var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    init() { }
    
    func perform() async throws -> some IntentResult {
        let context = ModelContext(Persistence.container)
        let predicate = #Predicate<Day> { $0.date == date }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        guard let day = try! context.fetch(descriptor).first else { return .result() }
        
        day.didStudy.toggle()
        try! context.save()
        
        if #available(iOS 18.0, *) {
            ControlCenter.shared.reloadControls(ofKind: "SwiftCalControl")
        }
        
        return .result()
    }
}

struct ControlToggleStudyIntent: SetValueIntent {
    static var title: LocalizedStringResource = "Control Toggle Studied"
    
    @Parameter(title: "Did Study")
    var value: Bool
    
    func perform() async throws -> some IntentResult {
        let context = ModelContext(Persistence.container)
        let today = Date()
        let predicate = #Predicate<Day> { $0.date == today.startOfDay }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        guard let day = try! context.fetch(descriptor).first else { return .result() }
        
        day.didStudy = value
        try! context.save()
        WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
        
        return .result()
    }
}
