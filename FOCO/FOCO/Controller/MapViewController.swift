//
//  MapViewController.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 11/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import MapKit

class MapViewController: UIViewController {
// MARK: Attributescode .git
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var points: [DiseaseAnnotation]?
    let regionRadius: CLLocationDistance = 1000
    
// MARK: Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 11.5, longitude: 12.5)
        loadInitialData()
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
    }
    
    // Centers map view on given location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Loads initial markers
    func loadInitialData() {
        // Loads disease occurences
        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
            if let data = points {
                // Maps occurrences to annotations
                self.points = data.map { (diseaseOccurrence) -> DiseaseAnnotation in
                    //The magic happens here
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
      let location = view.annotation as! DiseaseAnnotation
      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
