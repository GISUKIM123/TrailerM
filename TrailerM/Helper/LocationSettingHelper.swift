//
//  LocationSettingHelper.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-02.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit
import MapKit

class LocationSettingView: UIView, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationSettingHelper : LocationSettingHelper?
    
    let locationManager = CLLocationManager()
    
    var yourLocationCoordinate : CLLocationCoordinate2D?
    
    lazy var sharedButton : UIButton = {
        let button = UIButton()
        button.setTitle("Shared location", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(handleShared), for: .touchUpInside)
        button.titleLabel?.textAlignment    = .center
        button.backgroundColor              = .white
        button.showsTouchWhenHighlighted    = true
        
        return button
    }()
    
    @objc func handleShared() {
        print(123)
    }
    
    lazy var openButton : UIButton = {
        let button = UIButton()
        button.setTitle("Open in Maps", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(handleOpenInMaps), for: .touchUpInside)
        button.titleLabel?.textAlignment        = .center
        button.backgroundColor                  = .white
        button.showsTouchWhenHighlighted        = true
        
        return button
    }()
    
    @objc func handleOpenInMaps() {
        locationSettingHelper?.settingsController?.openMapInGoogleMap(location: yourLocationCoordinate!)
    }
    
    lazy var cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.titleLabel?.textAlignment    = .center
        button.backgroundColor              = .white
        button.showsTouchWhenHighlighted    = true
        
        return button
    }()
    
    @objc func handleCancel() {
        locationSettingHelper?.settingsController?.handleDismissView()
    }
    
    let mapView : MKMapView = {
        let mv = MKMapView()
        mv.showsScale               = true
        mv.showsPointsOfInterest    = true
        mv.showsUserLocation        = true
        
        return mv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.delegate                = self
        yourLocationCoordinate          = getYourLocation()
        setupMapView(yourLocation: yourLocationCoordinate!)
        
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        [
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.widthAnchor.constraint(equalTo: widthAnchor),
            mapView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55)
        ].forEach{ $0.isActive = true }
        
        addSubview(sharedButton)
        sharedButton.translatesAutoresizingMaskIntoConstraints = false
        [
            sharedButton.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            sharedButton.leftAnchor.constraint(equalTo: leftAnchor),
            sharedButton.widthAnchor.constraint(equalTo: widthAnchor),
            sharedButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
            ].forEach{ $0.isActive = true }
        addSubview(openButton)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        [
            openButton.topAnchor.constraint(equalTo: sharedButton.bottomAnchor),
            openButton.leftAnchor.constraint(equalTo: leftAnchor),
            openButton.widthAnchor.constraint(equalTo: widthAnchor),
            openButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
            ].forEach{ $0.isActive = true }
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        [
            cancelButton.topAnchor.constraint(equalTo: openButton.bottomAnchor),
            cancelButton.leftAnchor.constraint(equalTo: leftAnchor),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor),
            cancelButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
            ].forEach{ $0.isActive = true }
        
        
    }
    
    func setupMapView(yourLocation: CLLocationCoordinate2D) {
        // 0.1 is the standard
        let span        : MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location    : CLLocationCoordinate2D = CLLocationCoordinate2DMake(yourLocation.latitude, yourLocation.longitude)
        let region      : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = location
        annotation.title        = "Where you are"
        
        mapView.addAnnotation(annotation)
    }
    
    
    // get a coordinates of your location
    func getYourLocation() -> CLLocationCoordinate2D {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate            = self
            locationManager.desiredAccuracy     = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        return (locationManager.location?.coordinate)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LocationSettingHelper: NSObject {
    
    var containerView : UIView?
    weak var settingsController : SettingsController?
    
    func showLocationSettingBox() {
        if let keyWindow = UIApplication.shared.keyWindow {
            containerView?.frame                        = keyWindow.frame
            let locationSettingView                     = LocationSettingView()
            locationSettingView.locationSettingHelper   = self
            locationSettingView.layer.cornerRadius      = 50
            locationSettingView.clipsToBounds           = true
            locationSettingView.frame                   = CGRect(x: keyWindow.frame.width * 0.1, y: keyWindow.frame.height, width: keyWindow.frame.width * 0.8, height: keyWindow.frame.height * 0.6)
            containerView?.addSubview(locationSettingView)
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                locationSettingView.center              = keyWindow.center
            }) { (completed) in
                if completed {
                    
                }
            }
            
            keyWindow.addSubview(containerView!)
        }
    }
}
