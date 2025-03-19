//
//  Tracker.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
}
