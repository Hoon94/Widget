//
//  GameState.swift
//  BasketballSim
//
//  Created by Daehoon Lee on 5/3/25.
//

import Foundation

struct GameState {
    let homeScore: Int
    let awayScore: Int
    let scoringTeamName: String
    let lastAction: String
    
    var winningTeamName: String {
        homeScore > awayScore ? "warriors" : "bulls"
    }
}
