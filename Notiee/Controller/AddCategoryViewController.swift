//
//  AddCategoryViewController.swift
//  Notiee
//
//  Created by Kuba on 10/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

protocol reloadTableDelegate {
    func insertItem(category: Category)
}

class AddCategoryViewController: UIViewController {
    
    var delegate: reloadTableDelegate!
    
    var categoryName = "" {
        didSet {
            self.titleLabel.text = categoryName
        }
    }
    var categoryColor = "" {
        didSet {
            self.categoryCard.backgroundColor = UIColor(hex: categoryColor)
        }
    }
    
    var reloadButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
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
    
    var mapCard:MapCard = {
        let map = MapCard()
        map.layer.cornerRadius = 12
        map.layer.masksToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.backgroundColor = .black
        return map
    }()
    
    var hiddenTextField:UITextField = {
        let field = UITextField()
        field.isHidden = true
        field.returnKeyType = .done
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
        view.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            
            categoryCard.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            categoryCard.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            categoryCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            titleLabel.bottomAnchor.constraint(equalTo: categoryCard.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: categoryCard.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: categoryCard.widthAnchor),
            
            reloadButton.trailingAnchor.constraint(equalTo: categoryCard.trailingAnchor, constant: -10),
            reloadButton.topAnchor.constraint(equalTo: categoryCard.topAnchor, constant: 10),
            reloadButton.widthAnchor.constraint(equalToConstant: 30),
            reloadButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusTextField))
        titleLabel.addGestureRecognizer(tapGesture)
        
        reloadButton.addTarget(self, action: #selector(getRandomColor), for: .touchUpInside)
        hiddenTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        hiddenTextField.delegate = self
        
        getRandomColor()
        
        setupMapCard()
        
        hiddenTextField.becomeFirstResponder()
    //    setupToolbar()
    }
    
    func setupMapCard() {
        view.addSubview(mapCard)
        mapCard.delegate = self
        NSLayoutConstraint.activate([
            mapCard.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50),
            mapCard.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            mapCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapCard.topAnchor.constraint(equalTo: categoryCard.bottomAnchor, constant: 30),
        ])
        
    }
    
    /*
    func setupToolbar() {
        let toolbar = UIToolbar()
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(setMap))
        toolbar.items = [mapButton]
        toolbar.sizeToFit()
        hiddenTextField.inputAccessoryView = toolbar
    }
    
    
    @objc func setMap() {
        let vc = MapViewController()
        vc.categoryName = categoryName
        self.present(vc, animated: true, completion: nil)
    }
    */
    
    @objc
    func getRandomColor() {
        self.categoryColor = Store.getRandomStringColor()
    }
    
    @objc
    func focusTextField() {
        self.hiddenTextField.becomeFirstResponder()
    }
    
    @objc
    func textFieldDidChange(_ sender: UITextField) {
        if let text = sender.text {
            categoryName = text
        }
    }
}
extension AddCategoryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let category = Store.newCategory()
        
        if !categoryName.isEmpty {
            category.title = categoryName
        } else {
            return false
        }
        category.color = categoryColor
        Store.save()
        self.dismiss(animated: true, completion: {
            self.delegate.insertItem(category: category)
        })
        return true
    }
}

extension AddCategoryViewController: mapCardDelegate {
    func showMapVC() {
        print("tutaj")
        let map = MapViewController()
        self.present(map, animated: true, completion: nil)
    }
    
    
}


