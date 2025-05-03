//
//  BasketballSimApp.swift
//  BasketballSim
//
//  Created by Daehoon Lee on 5/3/25.
//

import SwiftUI

@main
struct BasketballSimApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(model: GameModel())
        }
    }
}
