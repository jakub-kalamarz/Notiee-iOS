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
    
    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(NoteViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    @objc func createNote() {
        let note = Store.newNote()
        self.notes.append(note)
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}


extension ViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteViewCell
        let note = notes[indexPath.row]
        cell.data = note
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 80)
    }


}

extension ViewController: NoteDataDelegate {
    func changeTitle(title: String, note: Note) {
        note.title = title
    }
    
    func changeText(text: String, note: Note) {
        note.text = text
    }
}
