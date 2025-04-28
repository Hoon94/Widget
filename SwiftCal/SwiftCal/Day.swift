//
//  Day.swift
//  SwiftCal
//
//  Created by Daehoon Lee on 4/28/25.
//
//

import Foundation
import SwiftData


@Model class Day {
    var date: Date
    var didStudy: Bool
    
    init(date: Date, didStudy: Bool) {
        self.date = date
        self.didStudy = didStudy
    }
}
