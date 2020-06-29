//
//  CategoryTableViewController.swift
//  Notiee
//
//  Created by Kuba on 25/06/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    //var categories = Store.fetchCategories()
    
    var categories = ["First", "Second"]
    
    var selected:Int! {
        didSet {
            print("xd")
            doneButton.isEnabled = true
        }
    }
    
    var delegate:categoryDelegate!
    
    var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAction))
        
        self.title = "Select Category"

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let data = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        //cell.data = data
        cell.contentView.layer.masksToBounds = true
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate.selectedCategory(category: categories[indexPath.row])
        let cell  = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        selected = indexPath.row
        cell.highligh()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        cell.unhighligh()
    }

}

extension CategoryTableViewController {
    
    @objc
    func doneAction() {
        print("Done \(selected)")
    }
    
    @objc
    func dismissAction() {
        print("Dismiss")
        self.dismiss(animated: true, completion: nil)
    }
}
