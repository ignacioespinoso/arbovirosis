//
//  Utils.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 21/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation
import Contacts
import MapKit

class Utils: NSObject {

    static func fixDateFormat(inputDate: String) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: inputDate) else {
            preconditionFailure(
                "Your input format is unexpected. Please follow the format: 'yyyy-MM-dd'T'HH:mm:ss.SSSZ'"
            )
        }
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fixedDate = dateFormatter.string(from: date)
        return fixedDate
    }

    static func getAddressText(coordinate: CLLocation, completion: @escaping (String?, Error?) -> Void) {

        var addressTxt = ""

        CLGeocoder().reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                // Handle Error
                completion(nil, error)
            } else if let results = placemarks,
                results.isEmpty == false {
                let result = results[0]

                let postalAddressFormatter = CNPostalAddressFormatter()
                postalAddressFormatter.style = .mailingAddress

                if let fullAddress = result.postalAddress {
                    addressTxt = postalAddressFormatter.string(from: fullAddress)
                } else if let city = result.locality, let state = result.administrativeArea {
                    addressTxt = city + ", " + state
                }

                completion(addressTxt, nil)
            }
        })

    }}
