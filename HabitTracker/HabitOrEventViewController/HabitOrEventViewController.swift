//
//  HabitOrEventViewController.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 20.03.2025.
//
import UIKit

protocol HabitOrEventViewControllerDelegate: AnyObject {
    func didCreateTracker(category: String, tracker: Tracker)
}

final class HabitOrEventViewController: UIViewController {
    enum TrackerType {
        case habit
        case event
    }
    
    weak var delegate: HabitOrEventViewControllerDelegate?
    var trackerType: TrackerType = .habit
    var weekDaysArrayForTracker: [WeekDay] = []
    var textFieldIsEmpty: Bool = true
    var trackerColor: UIColor?
    var trackerEmoji: String?
    var categoryForTracker: String = ""
    var weekdaysForTracker: String {
        var string: String = ""
        for i in weekDaysArrayForTracker {
            string += " \(i.shortDayName),"
        }
        return string
    }
    
    private let emojis = DataForHabitAndTracker.shared.emojis
    private let colors = DataForHabitAndTracker.shared.colors
    
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var titleLabel = UILabel()
    private lazy var nameTrackerTextField = UITextField()
    private lazy var trackerTableView = UITableView(frame: .zero)
    private lazy var createButton = UIButton()
    private lazy var cancelButton = UIButton(type: .system)
    private var rowsForTableView: [String] {
        return trackerType == .habit ? ["Категория", "Расписание"] : ["Категория"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        trackerTableView.dataSource = self
        trackerTableView.delegate = self
        configureSubviews()
    }
    
    private func configureSubviews() {
        scrollView.alwaysBounceVertical = true
        titleLabel.text = trackerType == .habit ? "Новая привычка" : "Новое событие"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .blackDay
        
        nameTrackerTextField.backgroundColor = .backgroundDay
        nameTrackerTextField.layer.masksToBounds = true
        nameTrackerTextField.layer.cornerRadius = 15
        nameTrackerTextField.font = .systemFont(ofSize: 16, weight: .regular)
        nameTrackerTextField.placeholder = "Введите название трекера"
        nameTrackerTextField.textAlignment = .left
        nameTrackerTextField.textColor = .blackDay
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 75))
        nameTrackerTextField.leftView = leftView
        nameTrackerTextField.leftViewMode = .always
        nameTrackerTextField.clearButtonMode = .whileEditing
        nameTrackerTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        trackerTableView.register(HabitOrEventTableViewСеll.self, forCellReuseIdentifier: HabitOrEventTableViewСеll.identifier)
        trackerTableView.separatorStyle = .singleLine
        trackerTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        trackerTableView.layer.masksToBounds = true
        trackerTableView.layer.cornerRadius = 16
        trackerTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HabitOrEventCollectionViewCell.self, forCellWithReuseIdentifier: HabitOrEventCollectionViewCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        
        createButton.setTitle("Создать", for: .normal)
        createButton.tintColor = .whiteDay
        createButton.backgroundColor = .ypGray
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 16
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonIsClicked), for: .touchUpInside)
        
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.backgroundColor = .whiteDay
        cancelButton.tintColor = .ypRed
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonIsClicked), for: .touchUpInside)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTrackerTextField.translatesAutoresizingMaskIntoConstraints = false
        trackerTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameTrackerTextField)
        contentView.addSubview(trackerTableView)
        contentView.addSubview(collectionView)
        contentView.addSubview(createButton)
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTrackerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTrackerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            
            trackerTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24),
            trackerTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerTableView.heightAnchor.constraint(equalToConstant: trackerType == .habit ? 150 : 75),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: trackerTableView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 700),
            
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 160),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 160),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func editingChanged() {
        if let text = nameTrackerTextField.text, !text.isEmpty {
            textFieldIsEmpty = false
            updateCreateButtonState()
        }
    }
    
    @objc private func cancelButtonIsClicked() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonIsClicked() {
        dismiss(animated: true)
        guard let color = trackerColor, let emoji = trackerEmoji else { return }
        var tracker: Tracker
        if let text = nameTrackerTextField.text {
            if trackerType == .habit {
                tracker = Tracker(id: UUID(), title: text, color: color, emoji: emoji, schedule: weekDaysArrayForTracker)
            } else {
                weekDaysArrayForTracker = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
                tracker = Tracker(id: UUID(), title: text, color: color, emoji: emoji, schedule: weekDaysArrayForTracker)
            }
            delegate?.didCreateTracker(category: categoryForTracker, tracker: tracker)
        }
    }
    
    internal func updateCreateButtonState() {
        if textFieldIsEmpty == false, (trackerType == .event || !weekDaysArrayForTracker.isEmpty), !categoryForTracker.isEmpty, trackerColor != nil, trackerEmoji != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = .blackDay
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        }
    }
}

extension HabitOrEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HabitOrEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowsForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HabitOrEventTableViewСеll.identifier, for: indexPath) as? HabitOrEventTableViewСеll else {
            assertionFailure("Failed to cast to EventOrHabitTableViewСеll")
            return UITableViewCell()
        }
        let text = rowsForTableView[indexPath.row]
        cell.configureNameLable(textNameLable: text)
        if indexPath.row == 0 {
            cell.configureDescriptionLable(textDescriptionLable: categoryForTracker)
        } else if trackerType == .habit && indexPath.row == 1 {
            if weekDaysArrayForTracker.count == 7 {
                cell.configureDescriptionLable(textDescriptionLable: "Каждый день")
            } else {
                cell.configureDescriptionLable(textDescriptionLable: weekdaysForTracker)
            }
        }
        cell.backgroundColor = .backgroundDay
        return cell
    }
}

extension HabitOrEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return emojis.count
        } else if section == 1 {
            return colors.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitOrEventCollectionViewCell.identifier, for: indexPath) as? HabitOrEventCollectionViewCell
        else {
            print("Failed to cast to HabitOrEventCollectionViewCell")
            return UICollectionViewCell()
        }

        cell.reset()
        if indexPath.section == 0 {
            cell.configEmojiCell(emoji: emojis[indexPath.row])

            if indexPath == selectedEmojiIndexPath {
                cell.selectEmoji()
            } else {
                cell.deselectEmoji()
            }

        } else if indexPath.section == 1 {
            cell.configColorCell(color: colors[indexPath.row])
            if indexPath == selectedColorIndexPath {
                let colorForBorder = colors[indexPath.row].withAlphaComponent(0.3)
                cell.selectColor(color: colorForBorder)
            } else {
                cell.deselectColor()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }

        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SectionHeader else {
            assertionFailure("Failed to cast to SectionHeader")
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else {
            view.titleLabel.text = "Цвет"
        }
        return view
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HabitOrEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Устанавливаем отступы от границ экрана до ячеек
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 19)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension HabitOrEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let selectedEmojiIndexPath = selectedEmojiIndexPath, let previousCell = collectionView.cellForItem(at: selectedEmojiIndexPath) as? HabitOrEventCollectionViewCell {
                previousCell.deselectEmoji()
            }
            selectedEmojiIndexPath = indexPath
            trackerEmoji = emojis[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) as? HabitOrEventCollectionViewCell {
                cell.selectEmoji()
            }
        } else {
            if let selectedColorIndexPath = selectedColorIndexPath, let previousCell = collectionView.cellForItem(at: selectedColorIndexPath) as? HabitOrEventCollectionViewCell {
                previousCell.deselectColor()
            }
            selectedColorIndexPath = indexPath
            trackerColor = colors[indexPath.row]
            if let cell = collectionView.cellForItem(at: indexPath) as? HabitOrEventCollectionViewCell {
                let colorForBorder = colors[indexPath.row].withAlphaComponent(0.3)
                cell.selectColor(color: colorForBorder)
            }
        }
        updateCreateButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HabitOrEventCollectionViewCell else {return}
        if indexPath.section == 0 {
            cell.deselectEmoji()
        } else {
            cell.deselectColor()
        }
        updateCreateButtonState()
    }
}



extension HabitOrEventViewController: ScheduleViewControllerDelegate {
    func weekdaysIsPicked(weekDaysArray: [WeekDay]) {
        weekDaysArrayForTracker = weekDaysArray
        trackerTableView.reloadData()
        updateCreateButtonState()
    }
}

