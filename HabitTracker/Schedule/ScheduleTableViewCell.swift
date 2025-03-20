//
//  ScheduleTableViewCell.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import UIKit

protocol ScheduleTableViewCellDelegate: AnyObject {
    func switchValueChanged(in cell: ScheduleTableViewCell)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    static let identifier = "ScheduleTableViewCell"
    private lazy var switchButton = UISwitch()
    private lazy var weekdaysLable = UILabel()
    
    weak var delegate: ScheduleTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        switchButton.isOn = false
        switchButton.onTintColor = .ypBlue
        switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        weekdaysLable.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(switchButton)
        contentView.addSubview(weekdaysLable)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchButton.heightAnchor.constraint(equalToConstant: 31),
            switchButton.widthAnchor.constraint(equalToConstant: 51),
            
            weekdaysLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weekdaysLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weekdaysLable.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor)
        ])
    }
    
    func configureCell(textLable: String) {
        weekdaysLable.text = textLable
    }
    
    func checkSwitchButtonStat() -> Bool {
        switchButton.isOn
    }
    func configureSwitchButtonStat(isOn: Bool) {
        switchButton.isOn = isOn
    }
    
    @objc func switchChanged() {
        delegate?.switchValueChanged(in: self)
    }
}
