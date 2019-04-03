//
//  ViewController.swift
//  CurrentLocation
//
//  Created by aly on 4/1/19.
//  Copyright © 2019 aly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    private let locationManger = CLLocationManager()
    private var CurrentCoordinat:CLLocationCoordinate2D?
    @IBOutlet weak var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureLocationServices()
    }
    
    
    private func ConfigureLocationServices() {
        locationManger.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined{
            locationManger.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            BeguineLocationUpdate(locationManger: locationManger)
        }
    }

    
    private func BeguineLocationUpdate(locationManger:CLLocationManager){
        MapView.showsUserLocation = true
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.startUpdatingLocation()
        
    }
    
    
    private func zoomToLatestLocation(with coordinat:CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion.init(center: coordinat, latitudinalMeters: 10000, longitudinalMeters: 10000)
        MapView.setRegion(zoomRegion, animated: true)
    }
    
}


extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get latest location")
        guard let LatestLocation = locations.first else { return  }
        if CurrentCoordinat == nil{
            zoomToLatestLocation(with: LatestLocation.coordinate)
        }
        CurrentCoordinat = LatestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            BeguineLocationUpdate(locationManger: manager)
        }
        
    }
}

