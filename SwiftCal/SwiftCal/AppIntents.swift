//
//  AppIntents.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/29/25.
//

import AppIntents
import Foundation
import SwiftData

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
        
        return .result()
    }
}
