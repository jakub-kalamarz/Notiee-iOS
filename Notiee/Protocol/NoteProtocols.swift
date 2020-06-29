//
//  NoteProtocols.swift
//  Notiee
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation
import UIKit

protocol NoteDelegate: class {
    func changeTitle(title:String, note:Note)
    func changeText(text:String, note:Note)
    func updateLayout(_ cell: NoteViewCell, with newSize: CGSize)
    func setAlarm(for note:Note)
    func setPeople(for note:Note)
    func setMap(for note:Note)
    func setCategory(for note:Note)
}

protocol NoteTextDelegate: class {
    func updateFrame(_ textView: UITextView)
}
