//
//  GameWidgetLiveActivity.swift
//  GameWidget
//
//  Created by Daehoon Lee on 5/4/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GameWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var gameState: GameState
    }
    
    // Fixed non-changing properties about your activity go here!
    var homeTeam: String
    var awayTeam: String
}

struct GameWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityView()
                .activityBackgroundTint(Color.cyan)
                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(.warriors)
                            .teamLogoModifier(frame: 40)
                        
                        Text("100")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("88")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Image(.bulls)
                            .teamLogoModifier(frame: 40)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(.warriors)
                            .teamLogoModifier(frame: 20)
                        
                        Text("S. Curry drains a 3")
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("5:24 3Q")
                }
            } compactLeading: {
                HStack {
                    Image(.warriors)
                        .teamLogoModifier()
                    
                    Text("100")
                        .fontWeight(.semibold)
                }
            } compactTrailing: {
                HStack {
                    Text("88")
                        .fontWeight(.semibold)
                    
                    Image(.bulls)
                        .teamLogoModifier()
                }
            } minimal: {
                Image(.warriors)
                    .teamLogoModifier()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GameWidgetAttributes {
    fileprivate static var preview: GameWidgetAttributes {
        GameWidgetAttributes(homeTeam: "Bulls", awayTeam: "Lakers")
    }
}

extension GameWidgetAttributes.ContentState {
    fileprivate static var sample: GameWidgetAttributes.ContentState {
        GameWidgetAttributes.ContentState(gameState: GameState(homeScore: 125, awayScore: 125, scoringTeamName: "Lakers", lastAction: "S. Curry drains a 3"))
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
