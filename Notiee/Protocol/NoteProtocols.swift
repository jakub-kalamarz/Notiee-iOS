//
//  NoteProtocols.swift
//  Notiee
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation

protocol NoteDataDelegate {
    func changeTitle(title:String, note:Note)
    func changeText(text:String, note:Note)
}
