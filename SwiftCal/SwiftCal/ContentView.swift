//
//  ContentView.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/22/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        animation: .default)
    private var days: FetchedResults<Day>
    
    // ["S", "M", "T", "W", "T", "F", "S"]
    let daysOfWeek = Calendar.current.veryShortWeekdaySymbols
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                        Text(dayOfWeek)
                            .fontWeight(.black)
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        Text(day.date?.formatted(.dateTime.day()) ?? Date.now.formatted())
                            .fontWeight(.bold)
                            .foregroundStyle(day.didStudy ? .orange : .secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background {
                                Circle()
                                    .foregroundStyle(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                            }
                    }
                }
                
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
