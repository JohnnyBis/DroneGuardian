//
//  MapViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/25/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import Geofirestore

let geoFirestoreRef = Firestore.firestore().collection("Users")
let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
var selectedPilotID: String = ""

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var findDroneButton: UIButton!
    
    @IBOutlet weak var dronePilotView: UICollectionView!
    let manager = CLLocationManager()
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    var searchLatitude: CLLocationDegrees = 0.0
    var searchLongitude: CLLocationDegrees = 0.0
    
    var pin: AnnotationPin!
    var dronePilot = [User]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        findDroneButton.layer.cornerRadius = 5
        dronePilotView.delegate = self
        dronePilotView.dataSource = self
        dronePilotView.allowsSelection = true
        dronePilot.removeAll()
        mapKit.delegate = self
        searchBar.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkAccountType()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
//                let annotations = self.mapKit.annotations
//                self.mapKit.removeAnnotations(annotations)
                
                //Getting data
                self.searchLatitude = (response?.boundingRegion.center.latitude)!
                self.searchLongitude = (response?.boundingRegion.center.longitude)!
                
                
                //Create annotation
                if pilot == false{
                    let annotation = MKPointAnnotation()
                    annotation.title = searchBar.text
                    annotation.subtitle = "My Location"
                    annotation.coordinate = CLLocationCoordinate2DMake(self.searchLatitude, self.searchLongitude)
                    self.mapKit.addAnnotation(annotation)
                }
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.searchLatitude, self.searchLongitude)
                let span = MKCoordinateSpanMake(0.5, 0.5)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapKit.setRegion(region, animated: true)
            }
            
        }

    }
    
    func checkAccountType(){
        User.fetchUserData(uid: uid!) { (user) in
            if user.pilot == true{
                self.findDroneButton.isHidden = true
                Missions.fetchUserMissions(uid: uid!, completionBlock: { (mission) in
                    let client = mission.client
                    self.findClientLocation(client: client)
                })
            }
        }
    }
    
    func findClientLocation(client: String){
        DataService.ds.REF_USERS.whereField("Full Name", isEqualTo: client).getDocuments(completion: { (doc, error) in
            if error != nil{
                print(error!)
            }else{
                for document in (doc?.documents)!{
                    let array = document.data()["l"] as? NSArray
                    let latitude = array![0] as! Double
                    let longitude = array![1] as! Double
                    self.addAnnotations(longitutde: longitude, latitude: latitude, dronePilot: client)
                }
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }else if annotation.coordinate.latitude == searchLatitude && annotation.coordinate.longitude == searchLongitude {
            let reuseID = "dronePin"
            var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            
            if v != nil {
                v?.annotation = annotation
            } else {
                v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                v?.canShowCallout = true
                
                v?.image = UIImage(named:"location-pin")
            }
            
            return v
            
        }else{
            let reuseID = "dronePin"
            var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
            
            if v != nil {
                v?.annotation = annotation
            } else {
                v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                v?.canShowCallout = true

                
                v?.image = UIImage(named:"drone")
            }
            
            return v
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.025, 0.025)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        if searchBar.text == ""{
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            mapKit.setRegion(region, animated: true)
            
        }
        
        print(location.altitude)
        print(location.speed)
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        geoFirestore.setLocation(location: CLLocation(latitude: latitude, longitude: longitude), forDocumentWithID: uid!)
        
        self.mapKit.showsUserLocation = true
    }

    @IBAction func findDroneButtonPressed(_ sender: UIButton) {
        var center: CLLocation
        if searchBar.text == ""{
            center = CLLocation(latitude: latitude, longitude: longitude)

        }else{
            center = CLLocation(latitude: searchLatitude, longitude: searchLongitude)

        }

        print(center)
        let circleQuery = geoFirestore.query(withCenter: center, radius: 3)
        circleQuery.observe(.documentEntered, with: { (key, location) in
            print("The document with documentID '\(key!)' entered the search area and is at location '\(location!)'")
            User.fetchUserData(uid: key!, completionBlock: { (user) in
                self.dronePilot.removeAll()
                print(self.dronePilot)
                if user.pilot == true && user.status == "Online"{
                    self.dronePilot.append(user)
                    print("Second \(self.dronePilot)")
                    DispatchQueue.main.async {
                        self.dronePilotView.reloadData()
                    }
                }
                self.dronePilotView.reloadData()
            })
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dronePilot.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dronePilotView.dequeueReusableCell(withReuseIdentifier: "dronePilot", for: indexPath) as! DronePilotCell
        let pilot = dronePilot[indexPath.row]
        cell.dronePilotName.text = pilot.username
        cell.box.layer.cornerRadius = 5
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPilotID = dronePilot[indexPath.row].userID
        performSegue(withIdentifier: "goToSetupFromMap", sender: self)
    }
    
    private func addAnnotations(longitutde: Double, latitude: Double, dronePilot: String) {
        let annotation = MKPointAnnotation()
        annotation.title = "\(dronePilot) - Mission"
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitutde))
        let location = CLLocation(latitude: latitude, longitude: longitutde)
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil{
                print(error!)
                return
            }
            
            if let placemarkArray = placemarks{
                if let placemark = placemarkArray.first{
                    annotation.subtitle = "\(placemark.name!), \(placemark.postalCode!)"
                }
            }
        }
        mapKit.addAnnotation(annotation)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "dronePin")
//        annotationView.image = UIImage(named: "drone")
//        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        annotationView.transform = transform
//        return annotationView
//    }
    
}
