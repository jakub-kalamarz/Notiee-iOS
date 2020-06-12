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
    
    var cells:[CGSize] = [CGSize]()
    
    private var newCellSize: CGSize = .init(width: UIScreen.main.bounds.width, height: 80)
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(NoteViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var emptyState = EmptyState()
    
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
    }
    
    func setupCollection() {
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupEmptyState() {
        self.view.addSubview(emptyState)
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyState.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            emptyState.widthAnchor.constraint(equalTo: emptyState.heightAnchor),
            emptyState.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            emptyState.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}


extension ViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = notes.count
        if count == 0 {
            setupEmptyState()
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteViewCell
        let note = notes[indexPath.row]
        cell.index = indexPath.row
        cell.data = note
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cells[safeIndex: indexPath.row] {
            return size
        } else {
            print(indexPath.row)
            cells.append(newCellSize)
            return newCellSize
        }
    }


}

extension ViewController: NoteDelegate {
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
