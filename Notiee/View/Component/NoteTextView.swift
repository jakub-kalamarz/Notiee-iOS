//
//  NoteTextView.swift
//  Notiee
//
//  Created by Kuba on 26/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

protocol NoteTextDelegate: class {
    func updateFrame()
    func backspaceAction()
}

class NoteTextView: UITextView {
    
    weak var coustomDelegate: NoteTextDelegate?
    
    var numberOfLines = 0
    
    override var contentSize: CGSize {
        didSet {
            coustomDelegate?.updateFrame()
        }
    }
    
    override func deleteBackward() {
        if self.text == "" {
            coustomDelegate?.backspaceAction()
        } else {
            super.deleteBackward()
        }
    }
}
