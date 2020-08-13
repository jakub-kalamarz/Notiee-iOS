//
//  MapViewController.swift
//  Notiee
//
//  Created by Kuba on 02/07/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    var data:Note!
    
    let mapView:MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let cancelButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.backgroundColor = UIColor.secondarySystemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        return button
    }()
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        mapView.center = view.center
        
        
        setupMap()
        setupCancelButton()
        setupLocationManager()
        setupPinAdd()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsBuildings = true
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
    }
    
    func setupPinAdd() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func addPin(_ sender:UIGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let cords = sender.location(in: mapView)
            let mapCords = mapView.convert(cords, toCoordinateFrom: mapView)
            let _ = CLLocation(latitude: mapCords.latitude, longitude: mapCords.longitude)
            
            let pin = MKPointAnnotation()
            pin.coordinate = mapCords
            pin.title = "PIN"
            mapView.addAnnotation(pin)
        }
    }
    
    func setupCancelButton() {
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ])
    }

}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
}
