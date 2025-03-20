//
//  HabitOrEventTableViewСеll.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 20.03.2025.
//

import UIKit

final class HabitOrEventTableViewСеll: UITableViewCell {
    
    static let identifier = "HabitOrEventTableViewСеll"
    
    private lazy var chevronImg: UIImageView = {
        return UIImageView(image: UIImage(named: "chevron"))
    }()
    private lazy var nameLable = UILabel()
    private lazy var descriptionLable = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        nameLable.font = .systemFont(ofSize: 17, weight: .regular)
        nameLable.textColor = .blackDay
        
        descriptionLable.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLable.textColor = .ypGray
        
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        chevronImg.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionLable)
        contentView.addSubview(chevronImg)
        contentView.addSubview(nameLable)
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            chevronImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronImg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImg.heightAnchor.constraint(equalToConstant: 24),
            chevronImg.widthAnchor.constraint(equalToConstant: 24),
            
            nameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLable.heightAnchor.constraint(equalToConstant: 24),
            nameLable.trailingAnchor.constraint(equalTo: chevronImg.leadingAnchor),
            nameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            descriptionLable.leadingAnchor.constraint(equalTo: nameLable.leadingAnchor),
            descriptionLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor),
            descriptionLable.trailingAnchor.constraint(equalTo: nameLable.trailingAnchor),
            descriptionLable.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configureNameLable(textNameLable: String) {
        nameLable.text = textNameLable
    }
    
    func configureDescriptionLable(textDescriptionLable: String) {
        var text = textDescriptionLable
        if text.last == "," {
            text.removeLast()
        }
        descriptionLable.text = text
    }
}

