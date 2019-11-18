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
    var dangerousAreas: [MKOverlay] = [MKOverlay]()
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
        // Loads disease occurences and coverage area
        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
            if let data = points {
                // Maps occurrences to annotations
                self.points = data.map { (diseaseOccurrence) -> DiseaseAnnotation in
                    // The magic happens here
                    let annotation = DiseaseAnnotation(disease: diseaseOccurrence)
                    self.dangerousAreas.append(MKCircle(center: annotation.coordinate, radius: 100))
                    return annotation
                }

                // Adds annotations and overlays to map view
                OperationQueue.main.addOperation {
                    if let data = self.points {
                        self.mapView.addAnnotations(data)
                        self.mapView.addOverlays(self.dangerousAreas)
                    }
                }
            } else {
                print(errorMessage.debugDescription)
            }
        }
    }

// MARK: Button Actions
    @IBAction func infoClick(_ sender: Any) {
        alertUnderConstruction()
    }

    @IBAction func recenterClick(_ sender: Any) {
        if let myLocation = locationManager.location {
            centerMapOnLocation(location: myLocation)
        }
    }

    @IBAction func newInputClick(_ sender: Any) {
        alertUnderConstruction()
    }
}

// MARK: Map View Delegate
extension MapViewController: MKMapViewDelegate {

    // Renders Map overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if overlay is MKCircle {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.fillColor = UIColor(hue: 9/360, saturation: 66/100, brightness: 92/100, alpha: 0.5)
            circleRender.lineWidth = 10

            return circleRender
        }
        return MKPolylineRenderer()
    }

    // Reuses annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var identifier = ""

        if annotation is DiseaseAnnotation {
            identifier = "diseaseMarker"
        } else {
            // if let annotation = annotation as? BreedingAnnotation {
                identifier = "breedinSiteMarker"
            //}
        }

        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
          as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            customizeView(view: view)
            view.glyphTintColor = .black
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }

    func customizeView(view: MKMarkerAnnotationView) {
        switch view.reuseIdentifier {
        case "diseaseMarker":
            view.glyphImage = UIImage(named: "sick")
            view.markerTintColor = UIColor(red: 249/255, green: 220/255, blue: 29/255, alpha: 1)
        case "breedingSiteMarker":
            view.glyphImage = UIImage(named: "mosquito")
            view.markerTintColor = UIColor(red: 70/255, green: 182/255, blue: 226/255, alpha: 1)
        default:
            view.markerTintColor = UIColor(red: 249/255, green: 220/255, blue: 29/255, alpha: 1)
        }
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
        let alert = UIAlertController(title: "Soon!", message: "Under construction.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
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

// MARK: CoreLocation Delegate
extension MapViewController: CLLocationManagerDelegate {
    func setupLocationServices() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if let myLocation = locationManager.location {
            centerMapOnLocation(location: myLocation)
        }
    }

    // Centers map view on a given location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}
