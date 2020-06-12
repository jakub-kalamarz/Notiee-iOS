//
//  ArrayExtension.swift
//  Notiee
//
//  Created by Kuba on 29/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }

        return self[index]
    }
    
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
    
}


