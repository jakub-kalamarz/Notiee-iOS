//
//  CollectionViewExtension.swift
//  Notiee
//
//  Created by Kuba on 23/05/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func reloadWithAnimation() {
        self.performBatchUpdates(
          {
            self.reloadSections(NSIndexSet(index: 0) as IndexSet)
          }, completion: { (finished:Bool) -> Void in
        })
    }
    
    func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
