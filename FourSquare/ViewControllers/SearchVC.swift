//
//  ViewController.swift
//  FourSquare
//
//  Created by Kevin Natera on 11/12/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var optionButton: UIButton!
    
    private let locationManager = CLLocationManager()
    
    var userLatitude = 40.742054
    var userLongitude = -73.769417
    let searchRadius: CLLocationDistance = 2000
    
    var annotations = [MKPointAnnotation]()
    var searchString: String? = nil
    
    var venues = [Venue]() {
        didSet {
            createAnnotations()
            mapView.addAnnotations(annotations)
        }
    }
    
  
    @IBAction func optionButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        requestLocationAndAuthorizeIfNeeded()
    }
    
    
    //MARK: - Private Methods
    private func loadData() {
        VenueAPIClient.shared.getVenues(lat: userLatitude, long: userLongitude, query: searchString) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let venuesFromOnline):
                    self.venues = venuesFromOnline
                    dump(venuesFromOnline)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setUp() {
        locationManager.delegate = self
        mapView.delegate = self
        locationSearchBar.delegate = self
        venueSearchBar.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    private func requestLocationAndAuthorizeIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func createAnnotations() {
        annotations = [MKPointAnnotation]()
        
        for (i,v) in venues.enumerated() {
            annotations.append(MKPointAnnotation())
            annotations[i].title = v.name
            annotations[i].coordinate = v.coordinate
        }
    }
    
    
}

//MARK: - Extensions

extension SearchVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New location: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension SearchVC: MKMapViewDelegate {
    
}


extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        searchBar.resignFirstResponder()
        
        switch searchBar {
            
        case venueSearchBar:
            
            if venueSearchBar.text == nil || venueSearchBar.text == "" {
                venueSearchBar.text = "Coffee"
                searchString = venueSearchBar.text
            }
            
            self.loadData()
            activityIndicator.stopAnimating()
            
        case locationSearchBar:
            
            if locationSearchBar.text == nil || locationSearchBar.text == "" {
                locationSearchBar.text = "New York"
                searchString = locationSearchBar.text
            }
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchBar.text
            let activeSearch = MKLocalSearch(request: searchRequest)
            activeSearch.start { (response, error) in
                activityIndicator.stopAnimating()
                if response == nil {
                    print(error)
                } else {
                    self.userLatitude = response?.boundingRegion.center.latitude ?? 40.742054
                    self.userLongitude = response?.boundingRegion.center.longitude ?? -73.769417
                    
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.title = response?.mapItems.first?.name
                    newAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.userLongitude)
                    self.mapView.addAnnotation(newAnnotation)
                    
                    let coordinateRegion = MKCoordinateRegion(center: newAnnotation.coordinate, latitudinalMeters: self.searchRadius * 2.0, longitudinalMeters: self.searchRadius * 2.0)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                    
                }
            }
        default:
            print("Que cosa")
        }
    }
}

