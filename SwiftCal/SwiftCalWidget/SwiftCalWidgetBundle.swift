//
//  SwiftCalWidgetBundle.swift
//  SwiftCalWidget
//
//  Created by Daehoon Lee on 4/23/25.
//

import SwiftUI
import WidgetKit

@main
struct SwiftCalWidgetBundle: WidgetBundle {
    var body: some Widget {
        SwiftCalWidget()
        if #available(iOS 18.0, *) {
            SwiftCalControl()
        }
    }
}
