//
//  AddCategoryViewController.swift
//  Notiee
//
//  Created by Kuba on 10/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController, UITextFieldDelegate {
    
    var categoryName = ""
    var categoryColor = "" {
        didSet {
            self.categoryCard.backgroundColor = UIColor(hex: categoryColor)
        }
    }
    
    var reloadButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        label.isUserInteractionEnabled = true
        label.text = "Category Title"
        return label
    }()
    
    var categoryCard:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var hiddenTextField:UITextField = {
        let field = UITextField()
        field.isHidden = true
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(categoryCard)
        view.addSubview(titleLabel)
        view.addSubview(hiddenTextField)
        hiddenTextField.delegate = self
        view.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            
            categoryCard.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            categoryCard.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            categoryCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleLabel.bottomAnchor.constraint(equalTo: categoryCard.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: categoryCard.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: categoryCard.widthAnchor),
            
            reloadButton.trailingAnchor.constraint(equalTo: categoryCard.trailingAnchor, constant: -10),
            reloadButton.topAnchor.constraint(equalTo: categoryCard.topAnchor, constant: 10),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusTextField))
        titleLabel.addGestureRecognizer(tapGesture)
        
        reloadButton.addTarget(self, action: #selector(getRandomColor), for: .touchUpInside)
        
        getRandomColor()
        
        hiddenTextField.becomeFirstResponder()
    }
    
    @objc
    func getRandomColor() {
        self.categoryColor = Store.getRandomStringColor()
    }
    
    @objc
    func focusTextField() {
        print("taped")
        print(hiddenTextField.canBecomeFirstResponder)
        self.hiddenTextField.becomeFirstResponder()
    }
}
