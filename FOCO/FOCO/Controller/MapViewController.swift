/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
ViewController for MapView

*/

import MapKit
import CoreLocation

class MapViewController: UIViewController {
// MARK: Attributescode .git
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newInputButton: UIView!
    fileprivate var points: [DiseaseAnnotation]?
    let regionRadius: CLLocationDistance = 400
    let locationManager = CLLocationManager()
    let maxSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

// MARK: Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        mapView.delegate = self
        self.setupLocationServices()

        // Creates rounded button
        newInputButton.layer.cornerRadius = 10
        newInputButton.clipsToBounds = true
    }

    // Loads initial markers
    func loadInitialData() {
        // Loads disease occurences
        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
            if let data = points {
                // Maps occurrences to annotations
                self.points = data.map { (diseaseOccurrence) -> DiseaseAnnotation in
                    // The magic happens here
                    let annotation = DiseaseAnnotation(disease: diseaseOccurrence)
                    return annotation
                }
                // Adds annotations to map view
                OperationQueue.main.addOperation {
                    if let data = self.points {
                        self.mapView.addAnnotations(data)
                    }
                }
            } else {
                print(errorMessage.debugDescription)
            }
        }
    }
    
    @IBAction func newInputClick(_ sender: Any) {
        alertUnderConstruction()
    }
}

// MARK: Map View Delegate
extension MapViewController: MKMapViewDelegate {

    // Reuses annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? DiseaseAnnotation else { return nil }

        let identifier = "diseaseMarker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
          as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
//        if let location = view.annotation as? DiseaseAnnotation {
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            location.mapItem().openInMaps(launchOptions: launchOptions)
//        }
        alertUnderConstruction()
    }

    func alertUnderConstruction() {
        let alert = UIAlertController(title: "Not Yet!", message: "We are working on developing this tool.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
        }}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func setupLocationServices() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    // Centers map view on given location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }

    // Centers map on user's location after change on their location
    // Future improvement: Change location only on first launch
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnLocation(location: manager.location!)
    }

}
