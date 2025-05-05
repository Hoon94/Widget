//
//  GameWidgetLiveActivity.swift
//  GameWidget
//
//  Created by Daehoon Lee on 5/4/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct GameWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityView(context: context)
                .activityBackgroundTint(Color.cyan)
                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(context.attributes.homeTeam)
                            .teamLogoModifier(frame: 40)
                            .contentTransition(.identity)
                        
                        Text("\(context.state.gameState.homeScore)")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.gameState.awayScore)")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Image(context.attributes.awayTeam)
                            .teamLogoModifier(frame: 40)
                            .contentTransition(.identity)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(context.state.gameState.scoringTeamName)
                            .teamLogoModifier(frame: 20)
                        
                        Text(context.state.gameState.lastAction)
                    }
                }
//                DynamicIslandExpandedRegion(.center) {
//                    Text("5:24 3Q")
//                }
            } compactLeading: {
                HStack {
                    Image(context.attributes.homeTeam)
                        .teamLogoModifier()
                        .contentTransition(.identity)
                    
                    Text("\(context.state.gameState.homeScore)")
                        .fontWeight(.semibold)
                }
            } compactTrailing: {
                HStack {
                    Text("\(context.state.gameState.awayScore)")
                        .fontWeight(.semibold)
                    
                    Image(context.attributes.awayTeam)
                        .teamLogoModifier()
                        .contentTransition(.identity)
                }
            } minimal: {
                Image(context.state.gameState.winningTeamName)
                    .teamLogoModifier()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GameWidgetAttributes {
    fileprivate static var preview: GameWidgetAttributes {
        GameWidgetAttributes(homeTeam: "warriors", awayTeam: "bulls")
    }
}

extension GameWidgetAttributes.ContentState {
    fileprivate static var sample: GameWidgetAttributes.ContentState {
        GameWidgetAttributes.ContentState(gameState: GameState(homeScore: 125, awayScore: 125, scoringTeamName: "warriors", lastAction: "S. Curry drains a 3"))
    }
}

#Preview("Content", as: .content, using: GameWidgetAttributes.preview) {
    GameWidgetLiveActivity()
} contentStates: {
    GameWidgetAttributes.ContentState.sample
}

#Preview("Expended", as: .dynamicIsland(.expanded), using: GameWidgetAttributes.preview) {
    GameWidgetLiveActivity()
} contentStates: {
    GameWidgetAttributes.ContentState.sample
}

#Preview("Compact", as: .dynamicIsland(.compact), using: GameWidgetAttributes.preview) {
    GameWidgetLiveActivity()
} contentStates: {
    GameWidgetAttributes.ContentState.sample
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: GameWidgetAttributes.preview) {
    GameWidgetLiveActivity()
} contentStates: {
    GameWidgetAttributes.ContentState.sample
}
