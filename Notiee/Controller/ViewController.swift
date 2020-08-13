//
//  ViewController.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var notes = Store.fetchNote()
    
    //var categories = Store.fetchCategories()
    var categories = ["First","Second","Third","Fourth","Last"]
    //let categories:[Category] = []
    
    var cells:[CGSize] = [CGSize]()
    
    private var newCellSize: CGSize = .init(width: UIScreen.main.bounds.width, height: 80)
    
    private lazy var categoryCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CategoryViewCell.self, forCellWithReuseIdentifier: "category")
        cv.register(AddCategoryViewCell.self, forCellWithReuseIdentifier: "add")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(NoteViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var emptyState = EmptyState(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    @objc func createNote() {
        let note = Store.newNote()
        self.notes.append(note)
        self.cells.append(newCellSize)
        self.collectionView.reloadData()
    }
    
    @objc func settings() {
        print("settings")
    }


}

// MARK:- Setup UI
extension ViewController {
    func setupUI() {
        setupNavigation()
        setupCollection()
    }
    
    func setupNavigation() {
        self.title = "Notiee"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(settings))
    }
    
    func setupCollection() {
        view.addSubview(collectionView)
        view.addSubview(categoryCollectionView)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupEmptyState() {
        self.view.addSubview(emptyState)
    }
}


extension ViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            let count = notes.count
            if count == 0 {
                self.setupEmptyState()
            } else {
                self.emptyState.removeFromSuperview()
            }
            return count
        case self.categoryCollectionView:
            return categories.count + 1
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
    switch collectionView {
        case self.collectionView:
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteViewCell
            let note = notes[index]
            cell.index = index
            cell.data = note
            cell.delegate = self
            return cell
        case categoryCollectionView:
            if index < categories.count {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryViewCell
                let category = categories[index]
                cell.data = category
                return cell
            } else {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "add", for: indexPath) as! AddCategoryViewCell
                cell.delegate = self
                return cell
            }
        default:
            break
    }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            if let size = cells[safeIndex: indexPath.row] {
                return size
            } else {
                cells.append(newCellSize)
                return newCellSize
            }
        case categoryCollectionView:
            if indexPath.row < categories.count {
                return CGSize(width: 130, height: 90)
            } else {
                return CGSize(width: 85, height: 90)
            }
        default:
            break
        }
        return CGSize(width: 0, height: 0)
    }
}

extension ViewController: NoteDelegate {
    func setCategory(for: Note) {
        print("Category")
    }
    
    func setAlarm(for: Note) {
        print("Alarm")
    }
    
    func setPeople(for: Note) {
        print("People")
    }
    
    func setMap(for: Note) {
        let vc = MapViewController()
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func updateLayout(_ cell: NoteViewCell, with newSize: CGSize) {
        let height = newSize.height
        cells[cell.index] = CGSize(width: newCellSize.width, height: height)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func changeTitle(title: String, note: Note) {
        note.title = title
    }
    
    func changeText(text: String, note: Note) {
        note.text = text
    }
}
//MARK:- Add Category Methods
extension ViewController:AddCategoryDelegate {
    func addCategoryAction() {
        let vc = AddCategoryViewController()
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
}
