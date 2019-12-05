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

    // MARK: - Get Formatted Date String
    static func fixDateFormat(inputDate: String) -> String {
        let dateFormatter =  DateFormatter()
        // Uses API format for dates.
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // Checks if the input is indeed a date in the  expected format.
        guard let date = dateFormatter.date(from: inputDate) else {
            preconditionFailure(
                "Your input format is unexpected. Please follow the format: 'yyyy-MM-dd'T'HH:mm:ss.SSSZ'"
            )
        }
        // Choose output date format
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let fixedDate = dateFormatter.string(from: date)
        return fixedDate
    }


    // MARK: - Get Full Address From a Coordinate
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

    }

    // MARK: - Get Customized Feedback Alert
    // Sets up an alert controller at given view, showing a message and a system image below it
    // The alert is automatically dismissed after the timer passes
    static func setupAlertController(viewController: UIViewController,
                                     message: String,
                                     systemImage: String,
                                     timer: Double) {
        let alert = UIAlertController(title: "Seu comentário foi adicionado com sucesso!",
                                      message: "\n\n\n",
                                      preferredStyle: .alert)

        let image = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        alert.view.addSubview(image)
        setupAlertControllerConstraints(alert: alert, image: image)
        viewController.present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + timer, execute: {
          alert.dismiss(animated: true, completion: nil)
        })
    }

    static func setupAlertControllerConstraints(alert: UIAlertController, image: UIImageView) {
        // Defines Constraints for image
        alert.view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: alert.view,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: alert.view,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: -8))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 64.0))
        alert.view.addConstraint(NSLayoutConstraint(item: image,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: 64.0))
    }
}
