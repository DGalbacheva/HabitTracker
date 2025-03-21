//
//  CategoryTableViewCell.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 21.03.2025.
//

import UIKit

final class CategoryTableViewСеll: UITableViewCell {
    
    static let identifier = "CategoryTableViewСеll"
    
    private lazy var doneImg: UIImageView = {
        return UIImageView(image: UIImage(named: "doneBlue"))
    }()
    
    private lazy var categoryLable = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        
        doneImg.isHidden = true
        
        categoryLable.translatesAutoresizingMaskIntoConstraints = false
        doneImg.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.addSubview(doneImg)
        contentView.addSubview(categoryLable)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            doneImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            doneImg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneImg.heightAnchor.constraint(equalToConstant: 24),
            doneImg.widthAnchor.constraint(equalToConstant: 24),
            
            categoryLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLable.trailingAnchor.constraint(equalTo: doneImg.leadingAnchor)
        ])
    }
    
    func configureCell(textLable: String) {
        categoryLable.text = textLable
    }
    
    func showOrHideDoneImg() {
        if doneImg.isHidden {
            doneImg.isHidden = false
        } else {
            doneImg.isHidden = true
        }
    }
    
    func getChoiсe() -> String {
        guard let text = categoryLable.text else {return "Без категории"}
        return text
    }
}

