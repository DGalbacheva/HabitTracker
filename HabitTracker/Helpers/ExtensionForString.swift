//
//  ExtensionForString.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 20.03.2025.
//

import Foundation

extension String {
    func toWeekdaysArray() -> [WeekDay] {
        return self.split(separator: ",").compactMap { WeekDay(rawValue: String($0)) }
    }
}
