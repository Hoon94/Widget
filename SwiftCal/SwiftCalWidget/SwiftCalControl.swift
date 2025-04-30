//
//  SwiftCalControl.swift
//  SwiftCalWidgetExtension
//
//  Created by Daehoon Lee on 4/30/25.
//

import SwiftUI
import WidgetKit

struct SwiftCalControl: ControlWidget {
    let kind: String = "SwiftCalControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetToggle("Study Swift",
                                isOn: Persistence.currentDay?.didStudy ?? false,
                                action: ControlToggleStudyIntent()) { isOn in
                Label(isOn ? "Studied Swift" : "Study Swift", systemImage: isOn ? "checkmark.circle" : "swift")
            }
                                .tint(.orange)
        }
        .displayName("Study Swift Today")
        .description("Mark that you studied Swift today.")
    }
}
