//
//  CategoryIndicator.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class CategoryIndicator: UIView {
    
    var color:CGColor!
    
    init(_ color:CGColor = UIColor.label.cgColor) {
        super.init(frame: .zero)
        self.color = color
        self.layer.backgroundColor = color
        self.layer.cornerRadius = 2
    }
    
    func setColor(color:CGColor) {
        UIView.animate(withDuration: 0.5) {
            self.layer.backgroundColor = color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
