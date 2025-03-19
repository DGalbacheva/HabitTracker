//
//  ScheduleTableViewCell.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import Foundation

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundDay
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
