//
//  ScheduleViewController.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 19.03.2025.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func weekdaysIsPicked(weekDaysArray: [WeekDay])
    func updateCreateButtonState()
}

// MARK: - Weekday Cell

final class ScheduleViewController: UIViewController {
    
    var weekDaysArrayFromVC: [WeekDay] = []
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var switchStates: [Bool] = [false, false, false, false, false, false, false]
    
    // MARK: - UI Elements
    
    private let navBar = UINavigationBar()
    
    private let weekDayTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackDay
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.whiteDay, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        
        weekDayTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 49)
        navBar.barTintColor = .whiteDay
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(navBar)
        let navTitle = UINavigationItem(title: "Расписание")
        navBar.setItems([navTitle], animated: false)
        
        addSubviews()
    }

    @objc private func doneButtonTapped() {
        delegate?.weekdaysIsPicked(weekDaysArray: weekDaysArrayFromVC)
        delegate?.updateCreateButtonState()
        dismiss(animated: true)
    }
    
    private func activateDoneButton() {
        doneButton.backgroundColor = .blackDay
        doneButton.isEnabled = true
    }
    
    private func deactivateDoneButton() {
        doneButton.backgroundColor = .ypGray
        doneButton.isEnabled = false
    }
    
    func updatedoneButtonnState() {
        if switchStates.contains(true) {
            activateDoneButton()
        } else {
            deactivateDoneButton()
        }
    }
    
    // MARK: - Layout
    
    private func addSubviews() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        weekDayTableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekDayTableView)
        view.addSubview(doneButton)
        
        weekDayTableView.dataSource = self
        weekDayTableView.delegate = self
        
        NSLayoutConstraint.activate([
            weekDayTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            weekDayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDayTableView.widthAnchor.constraint(equalToConstant: 75),
            weekDayTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Extensions

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else {
            assertionFailure("Не удалось выполнить приведение к WeekdaysTableViewCell")
            return UITableViewCell()
        }
        
        let weekday = WeekDay.allCases[indexPath.row]
        cell.configureCell(textLable: weekday.rawValue)
        for i in weekDaysArrayFromVC {
            if i.rawValue == weekday.rawValue {
                self.switchStates[indexPath.row] = true
                cell.configureSwitchButtonStat(isOn: true)
            }
        }
        cell.backgroundColor = .backgroundDay
        cell.delegate = self
        updatedoneButtonnState()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func switchValueChanged(in cell: ScheduleTableViewCell) {
        if let indexPath = weekDayTableView.indexPath(for: cell) {
            switchStates[indexPath.row] = cell.checkSwitchButtonStat()
            let weekDay = WeekDay.allCases[indexPath.row]
            if let weekdayIndex = weekDaysArrayFromVC.firstIndex(where: {$0 == weekDay}) {
                weekDaysArrayFromVC.remove(at: weekdayIndex)
                updatedoneButtonnState()
                return
            }
            weekDaysArrayFromVC.append(weekDay)
            updatedoneButtonnState()
        }
    }
}

