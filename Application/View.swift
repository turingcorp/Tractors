import UIKit
import MapKit

class View:UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private weak var map:MKMapView!
    private var location:CLLocationManager?
    private var lastLocation:CLLocation?
    private let presenter = Presenter()
    
    func centre(coordinate:CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.span = map.region.span
        region.center = coordinate
        map.setRegion(region, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("View.title", comment:String())
        makeOutlets()
        checkStatus()
        presenter.addMarkers = { [weak self] markers in
            self?.map.addAnnotations(markers)
        }
        presenter.removeMarkers = { [weak self] markers in
            self?.map.removeAnnotations(markers)
        }
        presenter.loadTractors()
    }
    
    func locationManager(_:CLLocationManager, didChangeAuthorization:CLAuthorizationStatus) {
        location = nil
    }
    
    func mapView(_:MKMapView, didUpdate location:MKUserLocation) {
        if map.selectedAnnotations.first as? MKPointAnnotation == nil {
            updateUser(location:location)
        }
    }
    
    func mapView(_:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        guard let mark = annotation as? MKPointAnnotation else { return map.view(for:annotation) }
        var point:MKAnnotationView!
        if let reuse = map.dequeueReusableAnnotationView(withIdentifier:"mark") {
            reuse.annotation = mark
            point = reuse
        } else {
            if #available(iOS 11.0, *) {
                let marker = MKMarkerAnnotationView(annotation:mark, reuseIdentifier:"mark")
                marker.markerTintColor = .green
                marker.animatesWhenAdded = true
                point = marker
            } else {
                let marker = MKPinAnnotationView(annotation:mark, reuseIdentifier:"mark")
                marker.pinTintColor = .green
                marker.animatesDrop = true
                point = marker
            }
            point.canShowCallout = true
            point.leftCalloutAccessoryView = UIImageView()
        }
        return point
    }
    
    private func makeOutlets() {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.delegate = self
        view.addSubview(map)
        self.map = map
        
        var region = MKCoordinateRegion()
        region.center = map.userLocation.coordinate
        region.span.latitudeDelta = 5
        region.span.longitudeDelta = 5
        map.setRegion(region, animated:false)
        
        map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:NSLocalizedString("View.centre", comment:String()),
                                                            style:.plain, target:self, action:#selector(centreUser))
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    private func checkStatus() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            location = CLLocationManager()
            location?.requestWhenInUseAuthorization()
        }
    }
    
    private func updateUser(location:MKUserLocation) {
        if let lastLocation = self.lastLocation {
            if let newLocation = location.location,
                lastLocation.distance(from:newLocation) > 35 {
                self.lastLocation = newLocation
                centre(coordinate:newLocation.coordinate)
            }
        } else {
            self.lastLocation = location.location
            centre(coordinate:location.coordinate)
        }
    }
    
    @objc private func centreUser() {
        centre(coordinate:map.userLocation.coordinate)
    }
}
