//
//  UIViewController.swift
//  Notiee
//
//  Created by Jakub Kalamarz on 27/08/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createResignOnTap() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
