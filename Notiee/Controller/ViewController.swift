//
//  ViewController.swift
//  Notiee
//
//  Created by Kuba on 22/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

//MARK:- Property Methods
class ViewController: UIViewController {
    
    var notes = Store.fetchNote()
    
    var categories = Store.fetchCategories()
    
    var cells:[CGSize] = [CGSize]()
    
    private var newCellSize: CGSize = .init(width: UIScreen.main.bounds.width, height: 80)
    
    private lazy var categoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Categories"
        return label
    }()
    
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
    
    private lazy var emptyState = EmptyState(frame: .zero,delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

}

// MARK:- Setup UI
extension ViewController: EmptyStateDelegate {
    
    @objc func createNote() {
        let note = Store.newNote()
        self.notes.append(note)
        self.cells.append(newCellSize)
        let index = IndexPath(row: notes.count - 1, section: 0)
        self.collectionView.insertItems(at: [index])
        let cell = collectionView.cellForItem(at: index) as! NoteViewCell
        cell.title.becomeFirstResponder()
    }
    
    @objc func settings() {
        print("settings")
    }

    
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupCollection()
        setupKeyboardResigner()
    }
    
    func setupKeyboardResigner() {
        let tap = createResignOnTap()
        self.view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
        self.collectionView.addGestureRecognizer(tap)
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupEmptyState() {
        self.view.addSubview(emptyState)
        
        NSLayoutConstraint.activate([
            emptyState.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            emptyState.heightAnchor.constraint(equalToConstant: 120),
            emptyState.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            emptyState.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyState.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK:- CollectionView Methods
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
            cell.indexPath = indexPath
            cell.data = note
            cell.delegate = self
            return cell
        case categoryCollectionView:
            if index < categories.count {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryViewCell
                let category = categories[index]
                cell.data = category
                cell.index = indexPath
                cell.delegate = self
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

//MARK:- Notes Methods
extension ViewController: NoteDelegate {
    func setCategory(for: Note) {
        print("Category")
    }
    
    func updateLayout(_ cell: NoteViewCell, with newSize: CGSize) {
        let height = newSize.height
        cells[cell.indexPath.row] = CGSize(width: newCellSize.width, height: height)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func changeTitle(title: String, note: Note) {
        note.title = title
    }
    
    func changeText(text: String, note: Note) {
        note.text = text
    }
    
    func deleteNote(note: Note, indexPath: IndexPath) {
        Store.delete(note)
        let index = notes.firstIndex(of: note)!
        notes.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        Store.save()
    }
}

//MARK:- Category Methods
extension ViewController:AddCategoryDelegate, CategoryCellDelegate, reloadTableDelegate {
    
    func showAlert(category: Category, index: IndexPath) {
        
        let alert = UIAlertController(title: "Menu", message: "Please Select an Option for \(category.title ?? "Category")", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("User click Edit button")
        }))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            guard let position = self.categories.firstIndex(of: category) else {
                return
            }
            let indexPath = IndexPath(row: position, section: 0)
            Store.delete(category)
            self.categories.remove(at: position)
            self.categoryCollectionView.deleteItems(at: [indexPath])
            Store.save()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addCategoryAction() {
        let vc = AddCategoryViewController()
        vc.delegate = self
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func insertItem(category: Category) {
        self.categories.append(category)
        let indexPath = IndexPath(row: categories.count - 1, section: 0)
        self.categoryCollectionView.insertItems(at: [indexPath])
        self.categoryCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        Store.save()
    }
    
}
