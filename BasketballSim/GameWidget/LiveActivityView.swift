//
//  LiveActivityView.swift
//  GameWidgetExtension
//
//  Created by Daehoon Lee on 5/4/25.
//

import SwiftUI
import WidgetKit

struct LiveActivityView: View {
    let context: ActivityViewContext<GameWidgetAttributes>
    
    var body: some View {
        ZStack {
            Image(.activityBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    ContainerRelativeShape()
                        .fill(.black.opacity(0.3).gradient)
                }
                .contentTransition(.identity)
            
            VStack(spacing: 12) {
                HStack {
                    Image(context.attributes.homeTeam)
                        .teamLogoModifier(frame: 60)
                        .contentTransition(.identity)
                    
                    Text("\(context.state.gameState.homeScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text("\(context.state.gameState.awayScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.black.opacity(0.8))
                    
                    Image(context.attributes.awayTeam)
                        .teamLogoModifier(frame: 60)
                        .contentTransition(.identity)
                }
                
                HStack {
                    Image(context.state.gameState.scoringTeamName)
                        .teamLogoModifier(frame: 20)
                    
                    Text(context.state.gameState.lastAction)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding()
        }
    }
}
