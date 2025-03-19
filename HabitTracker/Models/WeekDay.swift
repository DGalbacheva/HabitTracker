//
//  WeekDay.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"

    var calendarDayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }

    var shortDayName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}

extension WeekDay {
    static func fromDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: date)
        
        switch weekdayNumber {
        case 1: return WeekDay.sunday.rawValue
        case 2: return WeekDay.monday.rawValue
        case 3: return WeekDay.tuesday.rawValue
        case 4: return WeekDay.wednesday.rawValue
        case 5: return WeekDay.thursday.rawValue
        case 6: return WeekDay.friday.rawValue
        case 7: return WeekDay.saturday.rawValue
        default: return WeekDay.sunday.rawValue
        }
    }
}

