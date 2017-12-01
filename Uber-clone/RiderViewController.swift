//
//  RiderViewController.swift
//  Uber-clone
//
//  Created by Tanin on 01/12/2017.
//  Copyright © 2017 landtanin. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var map: MKMapView!
    @IBOutlet var callAnUberButton: UIButton!
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        // info.plist Privacy - Location When In Use
        locationManager.startUpdatingLocation()
        
        // check if there is current ride request in the database
        if let email = Auth.auth().currentUser?.email {
            
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                
                self.uberHasBeenCalled = true
                self.callAnUberButton.setTitle("Cancel Uber", for: .normal)
                
                Database.database().reference().child("RideRequests").removeAllObservers()
                
            })
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region =  MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations) // remove old annotations
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
            
        }
        
    }
    
    
    @IBAction func callUberTapped(_ sender: UIButton) {
        
        if let email = Auth.auth().currentUser?.email {
            
            if uberHasBeenCalled {
                
                uberHasBeenCalled = false
                callAnUberButton.setTitle("Call an Uber", for: .normal)
                
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                    
                    snapshot.ref.removeValue()
                    Database.database().reference().child("RideRequests").removeAllObservers()
                    
                })
                
            } else {
                
                let rideRequestDictionary : [String:Any] = ["email":email, "lat":userLocation.latitude, "lon":userLocation.longitude]
                
                Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                
                uberHasBeenCalled = true
                callAnUberButton.setTitle("Cancel Uber", for: .normal)
                
            }
            
        
            
        }
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
}
