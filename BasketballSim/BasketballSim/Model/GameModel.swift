//
//  GameModel.swift
//  BasketballSim
//
//  Created by Daehoon Lee on 5/3/25.
//

import ActivityKit
import Foundation

final class GameModel: ObservableObject, GameSimulatorDelegate {
    @Published var gameState = GameState(homeScore: 0,
                                         awayScore: 0,
                                         scoringTeamName: "",
                                         lastAction: "")
    
    let simulator = GameSimulator()
    var liveActivity: Activity<GameWidgetAttributes>? = nil
    
    init() {
        simulator.delegate = self
    }
    
    func startLiveActivity() {
        let attributes = GameWidgetAttributes(homeTeam: "warriors", awayTeam: "bulls")
        let currentGameState = GameWidgetAttributes.ContentState(gameState: gameState)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, contentState: currentGameState)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didUpdate(gameState: GameState) {
        self.gameState = gameState
        
        Task {
            await liveActivity?.update(using: .init(gameState: gameState))
        }
    }
    
    func didCompleteGame() {
        Task {
            await liveActivity?.end(using: .init(gameState: simulator.endGame()))
        }
    }
}
