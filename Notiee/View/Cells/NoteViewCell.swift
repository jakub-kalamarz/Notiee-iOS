//
//  NoteViewCell.swift
//  Notiee
//
//  Created by Kuba on 23/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class NoteViewCell: UICollectionViewCell {
    
    weak var delegate:NoteDelegate? {
        didSet {
            self.updateFrame()
        }
    }

    var indexPath: IndexPath!
    
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
            if let category = data.category {
                let cgcolor = UIColor(hex: category.color!)?.cgColor
                self.indicator.setColor(color: cgcolor!)
            } else {
                self.indicator.setColor(color: UIColor.label.cgColor)
            }
        }
    }

    
    private var indicator:CategoryIndicator = {
        let indicator = CategoryIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var title:CategoryTitleTextField = {
        let tf = CategoryTitleTextField()
        tf.font = .boldSystemFont(ofSize: 22)
        tf.placeholder = "Title"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var paragraph:NoteTextView = {
        let tv = NoteTextView()
        tv.font = .boldSystemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var moreIcon:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .link
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        self.contentView.addSubview(indicator)
        self.contentView.addSubview(title)
        self.contentView.addSubview(paragraph)
        self.contentView.addSubview(moreIcon)
        paragraph.coustomDelegate = self
        
        title.delegate = self
        title.textDelegate = self
        title.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
        title.addTarget(self, action: #selector(titleFocus(_:)), for: .editingDidBegin)
        title.addTarget(self, action: #selector(titleFocus(_:)), for: .editingDidEnd)
        paragraph.delegate = self
        moreIcon.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            indicator.topAnchor.constraint(equalTo: self.topAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 7),
            indicator.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            
            moreIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
            moreIcon.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            moreIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moreIcon.heightAnchor.constraint(equalTo: title.heightAnchor),
            
            paragraph.topAnchor.constraint(equalTo: title.bottomAnchor),
            paragraph.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            paragraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        ])
    }
    
    @objc
    func moreAction(_ sender:UIButton) {
        delegate?.showOptions(note: data, index: indexPath, cell: self)
    }
    
    @objc
    func titleFocus(_ sender:UITextField) {
        moreIcon.isHidden.toggle()
    }
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(color: CGColor) {
        indicator.setColor(color: color)
    }
}


extension NoteViewCell: NoteTextDelegate {
    
    func backspaceAction() {
        title.becomeFirstResponder()
    }
    
    func updateFrame() {
        let height = title.frame.height + paragraph.contentSize.height
        let newSize = CGSize(width: 0, height: height)
        delegate?.updateLayout(self, with: newSize)
    }
    
    
}

extension NoteViewCell: UITextViewDelegate, CoustomTextFieldDelegate {
    func isDescriptionEmpty() -> Bool {
        if self.paragraph.text == "" {
            return true
        } else {
            return false
        }
    }
    
    func deleteNote() {
        delegate?.deleteNote(note: data, indexPath: indexPath)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        paragraph.becomeFirstResponder()
    }
    
    @objc
    func titleChanged(_ textfield:UITextField) {
        if let text = textfield.text {
            delegate?.changeTitle(title: text, note: data)
        }
        Store.save()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            delegate?.changeText(text: text, note: data)
        }
        Store.save()
    }
}

protocol CoustomTextFieldDelegate:UITextFieldDelegate {
    func isDescriptionEmpty() -> Bool
    func deleteNote()
}

class CategoryTitleTextField: UITextField {
    
    var textDelegate:CoustomTextFieldDelegate!
    
    override func deleteBackward() {
        if text == "" && textDelegate.isDescriptionEmpty() {
            textDelegate.deleteNote()
        }
        super.deleteBackward()
    }
}

