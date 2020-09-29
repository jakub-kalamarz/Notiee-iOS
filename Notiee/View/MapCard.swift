//
//  mapCard.swift
//  Notiee
//
//  Created by Jakub Kalamarz on 08/09/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit
import MapKit

protocol mapCardDelegate {
    func showMapVC()
}

class MapCard: UIView {

    var mapView:MKMapView!
    
    var delegate:mapCardDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMap()
        setupAction()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMap() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: self.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: self.heightAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
    }
    
    func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(action(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc
    func action(_ tap:UIGestureRecognizer) {
        if tap.state == .ended {
            delegate.showMapVC()
        }
    }
    
}
