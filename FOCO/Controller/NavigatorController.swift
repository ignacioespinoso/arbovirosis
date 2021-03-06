/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
ViewController for MapView

*/

import MapKit
import CoreLocation

class NavigatorController: UIViewController {
// MARK: Attributescode .git
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!
    fileprivate var diseaseMarkers: [DiseaseAnnotation]?
    fileprivate var breedingMarkers: [BreedingAnnotation]?
    var dangerousAreas: [MKOverlay] = [MKOverlay]()
    let regionRadius: CLLocationDistance = 400
    let locationManager = CLLocationManager()
    let maxSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var selectedBreeedingSite: BreedingSite?
    var selectedLocation: CLLocation?
    let breedingSitesServices = BreedingSitesServices()
// MARK: Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
        mapView.delegate = self
        self.setupLocationServices()

        collaborateButton.layer.cornerRadius = 10
        collaborateButton.clipsToBounds = true
        collaborateButton.backgroundColor = .appOrangeYellow
        collaborateButton.tintColor = .black
        collaborateButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)

        // Long Press Gesture for New Item
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        self.mapView.addGestureRecognizer(longPressGesture)
    }

    // MARK: Button Actions
    @IBAction func refreshButton(_ sender: Any) {
        // Code to reload data from server
        // Needs fix: clicking fast, it loads twice.
        reloadData()
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
            circleRender.fillColor = .appCoralTranparent
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
        var calloutImage: UIImage?
        var calloutColor: UIColor?

        switch annotation {
        case is DiseaseAnnotation:
            identifier = "diseaseMarker"
            calloutImage = UIImage(named: "sick")
            calloutColor = .appGreenYellow
        // This is suppose to be BreedingSite instead o "DiseaseOccurrence"
        case is BreedingAnnotation:
            identifier = "breedingMarker"
            calloutImage = UIImage(named: "mosquito")
            calloutColor = .appBlueJeans
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
            view.glyphTintColor = .black
            view.glyphImage = calloutImage
            view.markerTintColor = calloutColor
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)

            // Setting image for the callout
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                      width: view.frame.height, height: view.frame.height))
            imageView.image = calloutImage
            imageView.tintColor = calloutColor
            imageView.contentMode = .scaleAspectFit
            view.leftCalloutAccessoryView = imageView

            if annotation is BreedingAnnotation {
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }

            // Allowing multiple lines on subtitle
            let subtitleView = UILabel()
            subtitleView.font = subtitleView.font.withSize(12)
            subtitleView.numberOfLines = 0
            subtitleView.text = annotation.subtitle!
            view.detailCalloutAccessoryView = subtitleView
        }
        return view
    }

    // Future performSegue() to "More Info" screen.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let breedingAnnotation = view.annotation as? BreedingAnnotation {
            selectedBreeedingSite = breedingAnnotation.breeding
            performSegue(withIdentifier: "showBreedingDetail", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showBreedingDetail":
                if let vc = segue.destination as? BreedingSiteDetailViewController {
                    vc.site = selectedBreeedingSite
                }
        case "newSite":
            if let vc = segue.destination as? UINavigationController,
                let dest = vc.viewControllers.first as? NewBreedingSiteViewController {
                dest.defaultLocation = selectedLocation
            }
        case "newOccurrence":
            if let vc = segue.destination as? UINavigationController,
                let dest = vc.viewControllers.first as? NewOccurrenceViewController {
                dest.defaultLocation = selectedLocation
            }
        default:
            print("None of those segues")
        }
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

    // If the user denied location, image will show location with a slash
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            locationIcon.image = UIImage(named: "fullButtonNotAllowedLocation")
            locationBtn.isEnabled = false
        }
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
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
            self.reloadData()
        })
        actionSheet.addAction(cancel)
        actionSheet.view.tintColor = .appDarkImperialBlue
        actionSheet.editButtonItem.tintColor = .appOrangeYellow

        for option in options {
            let currentOption = UIAlertAction(title: option.name, style: .default) { (_) in
                self.performSegue(withIdentifier: option.segueIdentifier, sender: self)
            }
            actionSheet.addAction(currentOption)
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.collaborateButton
                popoverController.sourceRect = CGRect(x: self.collaborateButton.bounds.midX,
                                                      y: self.collaborateButton.bounds.minY,
                                                      width: 0,
                                                      height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc func showOptions() {
        let option1 = Option(name: "Novo foco de água parada", segueIdentifier: "newSite")
        let option2 = Option(name: "Novo caso de doença", segueIdentifier: "newOccurrence")

        self.configureActionSheet(options: option1, option2)
    }

    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
        // Nunca passa por aqui
        self.reloadData()
    }
}

// MARK: Private Methods
extension NavigatorController {

    // Loads initial markers
    func loadInitialData() {
        // Loads disease occurences and coverage area
        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
            if let data = points {
                // Maps occurrences to annotations
                self.diseaseMarkers = data.map { (diseaseOccurrence) -> DiseaseAnnotation in
                    // The magic happens here
                    let annotation = DiseaseAnnotation(disease: diseaseOccurrence)
                    self.dangerousAreas.append(MKCircle(center: annotation.coordinate, radius: 250))
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
        breedingSitesServices.getAllSites { (errorMessage, points) in
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

    func reloadData() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        self.dangerousAreas = []
        self.diseaseMarkers = []
        self.breedingMarkers = []
        loadInitialData()
    }

    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {

        if gesture.state == .ended {
            // Frame location
            let point = gesture.location(in: self.mapView)
            // Map location
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            self.selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            // Creating annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            // Set title and subtitle if you want
            annotation.title = "Novo item"
            annotation.subtitle = "Contribua!"
            self.mapView.addAnnotation(annotation)
            self.showOptions()
        }
    }
}
