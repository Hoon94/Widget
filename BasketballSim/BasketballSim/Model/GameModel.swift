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
        let activityContent = ActivityContent(state: currentGameState, staleDate: nil)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, content: activityContent)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didUpdate(gameState: GameState) {
        self.gameState = gameState
        let currentGameState = GameWidgetAttributes.ContentState(gameState: gameState)
        let activityContent = ActivityContent(state: currentGameState, staleDate: nil)
        
        Task {
            await liveActivity?.update(activityContent)
        }
    }
    
    func didCompleteGame() {
        Task {
            let finalContent = GameWidgetAttributes.ContentState(gameState: simulator.endGame())
            await liveActivity?.end(ActivityContent(state: finalContent, staleDate: nil))
        }
    }
}
