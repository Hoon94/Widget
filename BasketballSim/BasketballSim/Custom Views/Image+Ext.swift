//
//  Image+Ext.swift
//  BasketballSim
//
//  Created by Daehoon Lee on 5/3/25.
//

import SwiftUI

extension Image {
    func teamLogoModifier(frame: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frame, height: frame)
    }
}
