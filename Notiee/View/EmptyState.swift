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
        
        
        let image = UIImage(named: "cat")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
