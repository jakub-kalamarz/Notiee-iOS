//
//  ViewController.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }


}

// MARK:- Setup UI
extension ViewController {
    func setupUI() {
        setupNavigation()
    }
    
    func setupNavigation() {
        self.title = "Notiee"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
