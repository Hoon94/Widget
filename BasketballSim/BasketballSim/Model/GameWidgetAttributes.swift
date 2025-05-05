//
//  GameWidgetAttributes.swift
//  BasketballSim
//
//  Created by Daehoon Lee on 5/5/25.
//

import ActivityKit
import Foundation

struct GameWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var gameState: GameState
    }
    
    // Fixed non-changing properties about your activity go here!
    var homeTeam: String
    var awayTeam: String
}
