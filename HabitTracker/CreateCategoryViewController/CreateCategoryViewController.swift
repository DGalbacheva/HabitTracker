//
//  CreateCategoryViewController.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 25.03.2025.
//

import UIKit

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func createNewCategory(newCategory: String)
}

final class CreateCategoryViewController: UIViewController {
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    
    private lazy var titleLabel = UILabel()
    private lazy var categoryTextField = UITextField()
    private lazy var doneButton = UIButton()
    private var textFromTextField: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
    }
    
    private func createSubView() {
        titleLabel.text = "Новая Категория"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .blackDay
        
        categoryTextField.backgroundColor = .backgroundDay
        categoryTextField.layer.masksToBounds = true
        categoryTextField.layer.cornerRadius = 15
        categoryTextField.font = .systemFont(ofSize: 17, weight: .regular)
        categoryTextField.placeholder = "Введите название категории"
        categoryTextField.textAlignment = .left
        categoryTextField.textColor = .blackDay
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 75))
        categoryTextField.leftView = leftView
        categoryTextField.leftViewMode = .always
        categoryTextField.clearButtonMode = .whileEditing
        
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = .ypGray
        doneButton.tintColor = .whiteDay
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        
        view.addSubview(titleLabel)
        view.addSubview(categoryTextField)
        view.addSubview(doneButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    @objc private func doneButtonClicked() {
        delegate?.createNewCategory(newCategory: textFromTextField!)
        dismiss(animated: true)
    }
    
    @objc private func textFieldEditingChanged() {
        if let text = categoryTextField.text, !text.isEmpty {
            textFromTextField = text
            activateDoneButton()
        } else {
            deactivateDoneButton()
        }
    }
    
    private func activateDoneButton() {
        doneButton.backgroundColor = .blackDay
        doneButton.isEnabled = true
    }
    
    private func deactivateDoneButton() {
        doneButton.backgroundColor = .ypGray
        doneButton.isEnabled = false
    }
}
