/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
ViewController for MapView

*/

import MapKit
import CoreLocation

class NavigatorController: UIViewController, UIActionSheetDelegate {
// MARK: Attributescode .git
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!
    fileprivate var diseaseMarkers: [DiseaseAnnotation]?
    fileprivate var breedingMarkers: [BreedingAnnotation]?
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

        collaborateButton.layer.cornerRadius = 10
        collaborateButton.clipsToBounds = true
        collaborateButton.backgroundColor = UIColor(red: 241/255, green: 216/255, blue: 109/255, alpha: 1)
        collaborateButton.tintColor = UIColor(red: 30/255, green: 64/255, blue: 103/255, alpha: 1)
        collaborateButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
    }

    // Loads initial markers
    func loadInitialData() {
        // Loads disease occurences and coverage area
        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
            if let data = points {
                // Maps occurrences to annotations
                self.diseaseMarkers = data.map { (diseaseOccurrence) -> DiseaseAnnotation in
                    // The magic happens here
                    let annotation = DiseaseAnnotation(disease: diseaseOccurrence)
                    self.dangerousAreas.append(MKCircle(center: annotation.coordinate, radius: 100))
                    return annotation
                }

                // Adds annotations and overlays to map view
                OperationQueue.main.addOperation {
                    if let data = self.diseaseMarkers {
                        self.mapView.addAnnotations(data)
                        self.mapView.addOverlays(self.dangerousAreas)
                    }
                }
            } else {
                print(errorMessage.debugDescription)
            }
        }

        // Loads breeding sites
        BreedingSitesServices.getAllSites { (errorMessage, points) in
            if let data = points {
                self.breedingMarkers = data.map { (breedingSite) -> BreedingAnnotation in
                    let annotation = BreedingAnnotation(breeding: breedingSite)
                    return annotation
                }
                OperationQueue.main.addOperation {
                    if let data = self.breedingMarkers {
                        self.mapView.addAnnotations(data)
                    }
                }
            } else {
                print(errorMessage.debugDescription)
            }
        }
    }
    // MARK: Button Actions
    @IBAction func refreshButton(_ sender: Any) {
        // Code to reload data from server
        // Needs fix: clicking fast, it loads twice.
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        self.dangerousAreas = []
        self.diseaseMarkers = []
        self.breedingMarkers = []
        loadInitialData()
    }

    @IBAction func recenterClick(_ sender: Any) {
        if let myLocation = locationManager.location {
            centerMapOnLocation(location: myLocation)
        }
        locationIcon.image = UIImage(named: "fullButtonFilled")
    }
}

// MARK: Map View Delegate
extension NavigatorController: MKMapViewDelegate {

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

    // Changes location button filling when map is dragged over 100 meters away from current location.
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let mapCenter = mapView.centerCoordinate
        if let myLocation = locationManager.location {
            let centerLocation = CLLocation(latitude: mapCenter.latitude, longitude: mapCenter.longitude)
            let distance = myLocation.distance(from: centerLocation)
            if distance > 100 {
                locationIcon.image = UIImage(named: "fullButtonUnfilled")
            }
        }
    }

    // Reuses annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var identifier = ""

        switch annotation {
        case is DiseaseAnnotation:
            identifier = "diseaseMarker"
        // This is suppose to be BreedingSite instead o "DiseaseOccurrence"
        case is BreedingAnnotation:
            identifier = "breedingMarker"
        // Nil return on default value is important for avoiding customization on user's location blue pin
        default:
            return nil
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
            // We are not currently showing callout because we haven't implemented "More Info" screen.
            view.canShowCallout = false
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
        case "breedingMarker":
            view.glyphImage = UIImage(named: "mosquito")
            view.markerTintColor = UIColor(red: 70/255, green: 182/255, blue: 226/255, alpha: 1)
        default:
            print("Not Implemented.")
        }
    }

    // Future performSegue() to "More Info" screen.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
//        if let location = view.annotation as? DiseaseAnnotation {
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//            location.mapItem().openInMaps(launchOptions: launchOptions)
//        }
    }
}

// MARK: CoreLocation Delegate & Settings
extension NavigatorController: CLLocationManagerDelegate {
    // Requests location permission and set Core Location
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

// MARK: Action Sheet Configuration
struct Option {
    var name: String
    var segueIdentifier: String
}

extension NavigatorController {
    func configureActionSheet(options: Option...) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)

        for option in options {
            let currentOption = UIAlertAction(title: option.name, style: .default) { (_) in
                self.performSegue(withIdentifier: option.segueIdentifier, sender: self)
            }
            actionSheet.addAction(currentOption)
        }
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc func showOptions() {
        let option1 = Option(name: "Novo foco", segueIdentifier: "newSite")
        let option2 = Option(name: "Nova ocorrência", segueIdentifier: "newOccurrence")

        self.configureActionSheet(options: option1, option2)
    }

    @IBAction func unwindToMap(segue: UIStoryboardSegue) { }
}
