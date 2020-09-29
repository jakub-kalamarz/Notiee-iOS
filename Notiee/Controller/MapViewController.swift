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
    
    var pin:MKPointAnnotation!
    
    public var categoryName = ""
    
    var range:Float = 0.1 {
        didSet(newValue) {
            self.rangeLabel.text = "\(String(format: "%.1f", newValue)) km"
            self.reloadPinCircle()
        }
    }
    
    var canDone:Bool = false {
        didSet(newValue) {
            doneButton.isHidden = newValue
            deleteButton.isHidden = newValue
        }
    }
    
    var pinCoordinate:CLLocationCoordinate2D!
    
    var pinCircle:MKCircle!
    
    lazy var rangeSlider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.1
        slider.value = 0.1
        slider.minimumValueImage = UIImage(systemName: "minus")
        slider.maximumValueImage = UIImage(systemName: "plus")
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .allEvents)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var rangeLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.range) km"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mapView:MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let cancelButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor.secondarySystemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
        return button
    }()
    
    let doneButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.green
        button.isHidden = true
        return button
    }()
    
    let deleteButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.red
        button.isHidden = true
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
        setupButtons()
        setupLocationManager()
        setupPinAdd()
    }
    
    @objc func dismissVC() {
        self.mapView.removeFromSuperview()
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
    
    func setupButtons() {
        view.addSubview(cancelButton)
        view.addSubview(deleteButton)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            
            deleteButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),

            
            ])
        
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

}
//MARK:- Map Pin Methods
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupSlider() {
        view.addSubview(rangeSlider)
        view.addSubview(rangeLabel)
        
        NSLayoutConstraint.activate([
            rangeSlider.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            rangeSlider.heightAnchor.constraint(equalToConstant: 40),
            rangeSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rangeSlider.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            rangeLabel.bottomAnchor.constraint(equalTo: rangeSlider.topAnchor),
            rangeLabel.centerXAnchor.constraint(equalTo: rangeSlider.centerXAnchor),
            
        ])
    }
    
    func setupPinAdd() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func addPin(_ sender:UIGestureRecognizer) {
        if sender.state == .began {
            if pin != nil {
                mapView.removeAnnotation(pin)
            }
            let cords = sender.location(in: mapView)
            let mapCords = mapView.convert(cords, toCoordinateFrom: mapView)
            let pinLocation = CLLocation(latitude: mapCords.latitude, longitude: mapCords.longitude)
            
            addPinCircle(location: pinLocation)
            pin = MKPointAnnotation()
            pin.coordinate = mapCords
            pin.title = categoryName
            mapView.addAnnotation(pin)
            
            setupSlider()
            canDone = true
        }
    }
    
    @objc func sliderValueChanged(_ sender:UISlider) {
        self.range = sender.value
    }
    
    func addPinCircle(location:CLLocation) {
        self.pinCoordinate = location.coordinate
        self.pinCircle = MKCircle(center: pinCoordinate, radius: CLLocationDistance(range * 1000))
        self.mapView.addOverlay(pinCircle)
    }
    
    func reloadPinCircle() {
        self.mapView.removeOverlay(self.pinCircle)
        self.pinCircle = MKCircle(center: self.pinCoordinate, radius: CLLocationDistance(self.range * 1000))
        self.mapView.addOverlay(self.pinCircle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = .label
        circle.fillColor = .clear
        circle.lineWidth = 1
        return circle
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let pin = self.pin else {
            return
        }
        if let distance = mapView.getUserDisance(from: pin) {
            print(distance)
        }
        
    }
    
}
