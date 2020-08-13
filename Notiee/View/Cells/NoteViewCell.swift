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

    
    private var indicator:CategoryIndicator = {
        let indicator = CategoryIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var title:UITextField = {
        let tf = UITextField()
        tf.font = .boldSystemFont(ofSize: 22)
        tf.placeholder = "Title"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private var paragraph:NoteTextView = {
        let tv = NoteTextView()
        tv.font = .boldSystemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var iconStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var alarmIcon:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "alarm.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var peopleIcon:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var mapIcon:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "mappin.circle"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        indicator.isUserInteractionEnabled = true
        indicator.addGestureRecognizer(gesture)
        
        //iconStack.addArrangedSubview(alarmIcon)
        //iconStack.addArrangedSubview(peopleIcon)
        //iconStack.addArrangedSubview(mapIcon)
        
        //alarmIcon.addTarget(self, action: #selector(alarmAction), for: .touchUpInside)
        //peopleIcon.addTarget(self, action: #selector(peopleAction), for: .touchUpInside)
        //mapIcon.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        
        //self.contentView.addSubview(iconStack)
        self.contentView.addSubview(indicator)
        self.contentView.addSubview(title)
        self.contentView.addSubview(paragraph)
        paragraph.coustomDelegate = self
        
        title.delegate = self
        title.addTarget(self, action: #selector(titleChanged(_:)), for: .editingChanged)
        paragraph.delegate = self

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            indicator.topAnchor.constraint(equalTo: self.topAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 7),
            indicator.heightAnchor.constraint(equalTo: self.heightAnchor),
            /*
            iconStack.heightAnchor.constraint(equalTo: title.heightAnchor),
            iconStack.widthAnchor.constraint(equalToConstant: 100),
            iconStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            */
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            paragraph.topAnchor.constraint(equalTo: title.bottomAnchor),
            paragraph.leadingAnchor.constraint(equalTo: indicator.trailingAnchor),
            paragraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        ])
    }
    
    @objc
    func longPress(_ sender:UIGestureRecognizer) {
        if sender.state == .began {
            delegate?.setCategory(for: self.data)
        }
    }
    
    @objc
    func alarmAction() {
        delegate?.setAlarm(for: self.data)
    }
    
    @objc
    func peopleAction() {
        delegate?.setPeople(for: self.data)
    }
    
    @objc
    func mapAction() {
        delegate?.setMap(for: self.data)
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
        Store.save()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            delegate?.changeText(text: text, note: data)
        }
        Store.save()
    }
}
