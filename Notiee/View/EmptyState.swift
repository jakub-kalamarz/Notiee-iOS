//
//  EmptyState.swift
//  Notiee
//
//  Created by Kuba on 12/06/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class EmptyState: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = "Add some notes!"
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 22)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
