//
//  NoteViewCell.swift
//  Notiee
//
//  Created by Kuba on 23/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class NoteViewCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    var delegate:NoteDataDelegate!
    var data:Note! {
        didSet {
            if let title = data.title {
                self.title.text = title
            } else {
                self.title.text = ""
            }
            if let text = data.text {
                self.paragraph.text = text
            } else {
                self.paragraph.text = ""
            }
        }
    }

    
    var indicator:CategoryIndicator = {
        let indicator = CategoryIndicator(color: UIColor(red: 27/255, green: 20/255, blue: 100/255, alpha: 1).cgColor)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var title:UITextField = {
        let tf = UITextField()
        tf.font = .boldSystemFont(ofSize: 25)
        tf.placeholder = "Title"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var paragraph:UITextView = {
        let tv = UITextView()
        tv.font = .boldSystemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(indicator)
        contentView.addSubview(title)
        contentView.addSubview(paragraph)
        
        title.delegate = self
        title.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
        paragraph.delegate = self
        

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            indicator.topAnchor.constraint(equalTo: self.topAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 7),
            indicator.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            paragraph.topAnchor.constraint(equalTo: title.bottomAnchor),
            paragraph.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            paragraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteViewCell: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        paragraph.becomeFirstResponder()
    }
    
    @objc
    func titleChanged(_ textfield:UITextField) {
        if let text = textfield.text {
            delegate.changeTitle(title: text, note: data)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            delegate.changeText(text: text, note: data)
        }
    }
}
