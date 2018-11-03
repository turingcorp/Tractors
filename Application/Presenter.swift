import Foundation
import Tractors
import MapKit

class Presenter:Delegate {
    var addMarkers:(([MKPointAnnotation]) -> Void)?
    var removeMarkers:(([MKPointAnnotation]) -> Void)?
    private var markers = [String:MKPointAnnotation]()
    private let catalog = Catalog()
    
    func loadTractors() {
        catalog.delegate = self
        catalog.startRequests()
    }
    
    func tractorsUpdated() {
        var toRemove = markers
        var toAdd = [MKPointAnnotation]()
        catalog.tractors.forEach { tractor in
            if let marker = toRemove.removeValue(forKey:tractor.id) {
                marker.coordinate = CLLocationCoordinate2D(latitude:tractor.latitude, longitude:tractor.longitude)
            } else {
                let marker = MKPointAnnotation()
                marker.title = NSLocalizedString("Presenter.marker", comment:String())
                marker.subtitle = tractor.driver
                marker.coordinate = CLLocationCoordinate2D(latitude:tractor.latitude, longitude:tractor.longitude)
                markers[tractor.id] = marker
                toAdd.append(marker)
            }
        }
        add(markers:toAdd)
        remove(markers:Array(toRemove.values))
    }
    
    private func add(markers:[MKPointAnnotation]) {
        if !markers.isEmpty {
            addMarkers?(markers)
        }
    }
    
    private func remove(markers:[MKPointAnnotation]) {
        if !markers.isEmpty {
            removeMarkers?(markers)
        }
    }
}
