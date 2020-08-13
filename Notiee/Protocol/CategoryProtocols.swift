//
//  CategoryProtocols.swift
//  Notiee
//
//  Created by Kuba on 28/06/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation

protocol categoryDelegate: class {
    func selectedCategory(category:Category)
    func addCategory()
}
