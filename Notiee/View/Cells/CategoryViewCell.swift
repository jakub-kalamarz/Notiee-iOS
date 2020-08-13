//
//  CategoryViewCell.swift
//  Notiee
//
//  Created by Kuba on 01/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    /*
    var data:Category! {
        didSet {
            title.text = data.title
        }
    }
     */
    
    var data:String! {
        didSet {
            title.text = data
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
    }
}
