//
//  ExtensionForArray.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 20.03.2025.
//

import Foundation

extension Array where Element == WeekDay {
    func toString() -> String {
        return self.map { $0.rawValue }.joined(separator: ",")
    }
}
