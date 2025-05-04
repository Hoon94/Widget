//
//  GameWidgetBundle.swift
//  GameWidget
//
//  Created by Daehoon Lee on 5/4/25.
//

import WidgetKit
import SwiftUI

@main
struct GameWidgetBundle: WidgetBundle {
    var body: some Widget {
        GameWidget()
        GameWidgetLiveActivity()
    }
}
