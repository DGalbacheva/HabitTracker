//
//  HabitOrEventCollectionViewCell.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 20.03.2025.
//

import UIKit

final class HabitOrEventCollectionViewCell: UICollectionViewCell {

    static let identifier = "HabitOrEventCollectionViewCell"
    
    private lazy var emojiLabel = UILabel()
    private lazy var colorView = UIView()
    private lazy var backView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviewsAndConstraints() {
        backView.backgroundColor = .whiteDay
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 8

        emojiLabel.backgroundColor = .whiteDay
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.textAlignment = .center
        emojiLabel.font = .systemFont(ofSize: 32, weight: .bold)

        colorView.backgroundColor = .whiteDay
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8

        backView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(backView)
        backView.addSubview(colorView)
        backView.addSubview(emojiLabel)


        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: 46),
            backView.widthAnchor.constraint(equalToConstant: 46),
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            emojiLabel.heightAnchor.constraint(equalToConstant: 38),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configEmojiCell(emoji: String) {
        emojiLabel.text = emoji
        colorView.isHidden = true
        contentView.layer.cornerRadius = 16
    }

    func configColorCell(color: UIColor) {
        emojiLabel.isHidden = true
        colorView.backgroundColor = color
        contentView.layer.cornerRadius = 8
    }

    func deselectEmoji() {
        contentView.backgroundColor = .whiteDay
        backView.backgroundColor = .whiteDay
        colorView.backgroundColor = .whiteDay
        emojiLabel.backgroundColor = .whiteDay
    }

    func deselectColor() {
        contentView.backgroundColor = .whiteDay
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
    }

    func selectEmoji() {
        contentView.backgroundColor = .ypLightGray
        backView.backgroundColor = .ypLightGray
        colorView.backgroundColor = .ypLightGray
        emojiLabel.backgroundColor = .ypLightGray
    }

    func selectColor(color: UIColor) {
        contentView.layer.borderColor = color.cgColor
        contentView.layer.borderWidth = 3
    }

    func reset() {
        emojiLabel.text = ""
        colorView.isHidden = false
        emojiLabel.isHidden = false
        colorView.backgroundColor = .white
        backView.backgroundColor = .white
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
    }
}

