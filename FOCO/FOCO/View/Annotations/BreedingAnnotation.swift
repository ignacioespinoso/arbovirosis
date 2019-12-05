//
//  BreedingAnnotation.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 18/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import MapKit
import Contacts

class BreedingAnnotation: NSObject, MKAnnotation {
    let breeding: BreedingSite
    let coordinate: CLLocationCoordinate2D

    init(breeding: BreedingSite) {
        self.breeding = breeding
        self.coordinate = CLLocationCoordinate2D(latitude: breeding.latitude, longitude: breeding.longitude)
        super.init()
    }

    var title: String? {
        return breeding.title
    }

    var subtitle: String? {
        // Future: return disease.initialSymptoms
        return "Entre para mais informações!"
    }
}

extension BreedingAnnotation {
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
      let addressDict = [CNPostalAddressStreetKey: subtitle!]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
}
