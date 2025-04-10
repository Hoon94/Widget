//
//  ContributorMediumView.swift
//  RepoWatcherWidgetExtension
//
//  Created by Daehoon Lee on 4/10/25.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                      alignment: .leading,
                      spacing: 20) {
                ForEach(0..<4) { i in
                    HStack {
                        Image(uiImage: UIImage(resource: .avatar))
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Sean Allen")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            
                            Text("42")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    ContributorMediumView()
//}
