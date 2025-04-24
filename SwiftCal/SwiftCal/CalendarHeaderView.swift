//
//  CalendarHeaderView.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/24/25.
//

import SwiftUI

struct CalendarHeaderView: View {
    // ["S", "M", "T", "W", "T", "F", "S"]
    let daysOfWeek = Calendar.current.veryShortWeekdaySymbols
    var font: Font = .body
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CalendarHeaderView()
}
