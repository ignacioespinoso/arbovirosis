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

    }

    // Alert Controller with 2 actions, needed for destructive actions (report)
    static func setupReportAlertController(viewController: UIViewController,
                                           isComment: Bool,
                                           completion: @escaping () -> Void) {

        // 2 use cases from this funcion
        let title: String = (isComment) ? "Reportar este comentário?" : "Reportar este foco?"

        let alert = UIAlertController(title: title,
                                      message: "Esta ação pode apagar esta informação. Deseja continuar?\n\n\n\n",
                                      // \n is for Symbol layout
                                      preferredStyle: .alert)

        if let image = UIImage(systemName: "exclamationmark.bubble.fill") {
            let coloredImage = image.withTintColor(.appDarkImperialBlue, renderingMode: .alwaysOriginal)

            let iconView = UIImageView(image: coloredImage)
            iconView.contentMode = .scaleAspectFit
            alert.view.addSubview(iconView)

            setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -48)

            let reportAction = UIAlertAction(title: "Reportar", style: .destructive) { (_: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
                completion()
            }

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }

            alert.addAction(reportAction)
            alert.addAction(cancelAction)

            viewController.present(alert, animated: true, completion: nil)
        } else {
            print("Invalid systemImage name")
        }
    }

    // Sets up an alert controller at given view, showing a message and a system image below it
    // The alert is automatically dismissed after the timer passes
    static func setupAlertControllerWithTitle(viewController: UIViewController,
                                              title: String,
                                              message: String,
                                              systemImage: String,
                                              color: UIColor,
                                              timer: Double?,
                                              completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message + "\n\n\n\n",
                                      preferredStyle: .alert)

        if let image = UIImage(systemName: systemImage) {
            let coloredImage = image.withTintColor(color, renderingMode: .alwaysOriginal)

            let iconView = UIImageView(image: coloredImage)
            iconView.contentMode = .scaleAspectFit
            alert.view.addSubview(iconView)

            if let countdown = timer {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -8)
                DispatchQueue.main.asyncAfter(deadline: .now() + countdown, execute: {
                               alert.dismiss(animated: true, completion: nil)
                               completion()
                           })
            } else {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -48)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                    completion()
                }

                alert.addAction(okAction)
            }
            viewController.present(alert, animated: true, completion: nil)
        } else {
            print("Invalid systemImage name")
        }
    }

    // Sets up an alert controller at given view, showing a message and a system image below it
    // The alert is automatically dismissed after the timer passes
    static func setupAlertController(viewController: UIViewController,
                                     message: String,
                                     systemImage: String,
                                     color: UIColor,
                                     timer: Double?,
                                     completion: @escaping () -> Void) {
        let alert = UIAlertController(title: message,
                                      message: "\n\n\n",
                                      preferredStyle: .alert)

        if let image = UIImage(systemName: systemImage) {
            let coloredImage = image.withTintColor(color, renderingMode: .alwaysOriginal)

            let iconView = UIImageView(image: coloredImage)
            iconView.contentMode = .scaleAspectFit
            alert.view.addSubview(iconView)

            if let countdown = timer {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -8)
                DispatchQueue.main.asyncAfter(deadline: .now() + countdown, execute: {
                               alert.dismiss(animated: true, completion: nil)
                               completion()
                           })
            } else {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -48)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                    completion()
                }

                alert.addAction(okAction)
            }
            viewController.present(alert, animated: true, completion: nil)
        } else {
            print("Invalid systemImage name")
        }
    }

    // Sets up an alert controller at given view, showing a message and a system image below it
    // The alert is automatically dismissed after the timer passes
    static func setupAlertController(viewController: UIViewController,
                                     message: String,
                                     systemImage: String,
                                     timer: Double?,
                                     completion: @escaping () -> Void) {
        let alert = UIAlertController(title: message,
                                      message: "\n\n\n",
                                      preferredStyle: .alert)

        if let image = UIImage(systemName: systemImage) {
            let iconView = UIImageView(image: image)
            alert.view.addSubview(iconView)

            if let countdown = timer {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -8)
                DispatchQueue.main.asyncAfter(deadline: .now() + countdown, execute: {
                               alert.dismiss(animated: true, completion: nil)
                               completion()
                           })
            } else {
                setupAlertControllerConstraints(alert: alert, image: iconView, bottomConstraint: -48)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (_: UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                    completion()
                }

                alert.addAction(okAction)
            }
            viewController.present(alert, animated: true, completion: nil)

        } else {
            print("Invalid systemImage name")
        }
    }

    static func setupAlertControllerConstraints(alert: UIAlertController,
                                                image: UIImageView,
                                                bottomConstraint: CGFloat) {
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
                                                   constant: bottomConstraint))
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

    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
