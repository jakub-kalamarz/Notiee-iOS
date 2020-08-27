//
//  EmptyState.swift
//  Notiee
//
//  Created by Kuba on 12/06/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

protocol EmptyStateDelegate {
    func createNote()
}

class EmptyState: UIView {
    
    var delegate:EmptyStateDelegate
    
    init(frame: CGRect, delegate:EmptyStateDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let first = "Add some "
        let second = " notes!"
        
        let button = UIButton()
        button.setTitle("new", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.addTarget(self, action: #selector(newAction), for: .touchUpInside)
        button.setTitleColor(.link, for: .normal)
        
        
        let firstLabel = UILabel()
        firstLabel.text = first
        firstLabel.textAlignment = .right
        firstLabel.font = .boldSystemFont(ofSize: 22)
        
        let secondLabel = UILabel()
        secondLabel.text = second
        secondLabel.font = .boldSystemFont(ofSize: 22)
        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, button, secondLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc
    func newAction() {
        delegate.createNote()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
