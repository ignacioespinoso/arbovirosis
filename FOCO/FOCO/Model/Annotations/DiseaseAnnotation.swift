//
//  DiseaseAnnotation.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 11/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import MapKit
import Contacts

class DiseaseAnnotation: NSObject, MKAnnotation {
    let disease: DiseaseOccurrence
    let coordinate: CLLocationCoordinate2D
    
    init(disease: DiseaseOccurrence) {
        self.disease = disease
        self.coordinate = CLLocationCoordinate2D(latitude: disease.latitude, longitude: disease.longitude)
        
        super.init()
    }
    
    var title: String? {
        return disease.diseaseName
    }
    
    var subtitle: String? {
        return String(disease.id)
    }
}

extension DiseaseAnnotation {
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
      let addressDict = [CNPostalAddressStreetKey: subtitle!]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}

