//
//  AddCategoryViewCell.swift
//  Notiee
//
//  Created by Kuba on 05/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategoryAction() -> Void
        }

class AddCategoryViewCell: UICollectionViewCell {
    
    var delegate:AddCategoryDelegate!
    
    let addButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = .darkText
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(addButton)
        
        imageView = addButton.imageView
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalTo: widthAnchor),
            addButton.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 35),
            imageView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
    }
    
    @objc
    func addAction() {
        delegate.addCategoryAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
