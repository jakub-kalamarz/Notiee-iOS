//
//  NoteViewCell.swift
//  Notiee
//
//  Created by Kuba on 23/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class NoteViewCell: UICollectionViewCell {
    
    weak var delegate:NoteDelegate?
    
    var index: Int!
    
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
    
    private var paragraph:NoteTextView = {
        let tv = NoteTextView()
        tv.font = .boldSystemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(indicator)
        self.addSubview(title)
        self.addSubview(paragraph)
        paragraph.coustomDelegate = self
        
        title.delegate = self
        title.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
        paragraph.delegate = self
        

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            indicator.topAnchor.constraint(equalTo: self.topAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 7),
            indicator.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            paragraph.topAnchor.constraint(equalTo: title.bottomAnchor),
            paragraph.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            paragraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        ])
    }

    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension NoteViewCell: NoteTextDelegate {
    func updateFrame(_ textView: UITextView) {
        let height = textView.contentSize.height + title.frame.height
        let newSize = CGSize(width: 0, height: height)
        delegate?.updateLayout(self, with: newSize)
    }
    
    
}

extension NoteViewCell: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        paragraph.becomeFirstResponder()
    }
    
    @objc
    func titleChanged(_ textfield:UITextField) {
        if let text = textfield.text {
            delegate?.changeTitle(title: text, note: data)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            delegate?.changeText(text: text, note: data)
        }
    }
}
