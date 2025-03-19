//
//  ScheduleDelegate.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import Foundation

protocol ScheduleDelegate: AnyObject {
    func weekDaysChanged(weedDays: [WeekDay])
}
