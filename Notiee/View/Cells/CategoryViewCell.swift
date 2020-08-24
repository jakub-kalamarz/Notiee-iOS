//
//  CategoryViewCell.swift
//  Notiee
//
//  Created by Kuba on 01/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {
    func showAlert(category: Category, index: IndexPath)
}

class CategoryViewCell: UICollectionViewCell {
    
    var delegate:CategoryCellDelegate!
    
    var index:IndexPath!
    
    var data:Category! {
        didSet {
            title.text = data.title
            if let colorString = data.color {
                let color = UIColor(hex: colorString)
                layer.backgroundColor = color?.cgColor
            }
        }
    }

    var title:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBackground
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.widthAnchor.constraint(equalTo: widthAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        layer.backgroundColor = Store.getRandomColor()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc
    func longPress(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            delegate.showAlert(category: data, index: index)
        }
    }
}
