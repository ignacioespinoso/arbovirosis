//
//  NewOccurrenceViewController.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 19/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation

class NewOccurrenceViewController: FormViewController {

    let locationManager = CLLocationManager()
    var defaultLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Cancelar",
                                         style: .plain,
                                         target: self,
                                         action: #selector(back(sender:)))

        self.navigationItem.backBarButtonItem = backButton
        let doneButton = UIBarButtonItem(title: "Pronto",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveOccurrence))

        backButton.tintColor = .appDarkImperialBlue
        doneButton.tintColor = .appDarkImperialBlue

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.title = "Nova Ocorrência"

        // Defines form row and cells
        form +++ Section("Dados do Paciente")
            <<< DateRow("symptomsStart") { row in
                row.title = "Início dos sintomas"
            }.cellSetup({ (cell, _) in
                cell.datePicker.locale = Locale(identifier: "pt_BR")
                cell.datePicker.maximumDate = Date()
            }).cellUpdate { (cell, row) in
                if row.value != nil {
                    cell.textLabel?.textColor = .black
                }
            }

        +++ Section(header: "Informações do Caso",
                    footer: "Informe para diferenciarmos suspeitas de casos confirmados.")
            <<< LocationRow("location") {
                $0.title = "Localização"
                $0.value = defaultLocation ?? locationManager.location
            }.cellUpdate { cell, row in
                if row.value != nil {
                    cell.textLabel?.textColor = .black
                }
            }
            <<< PickerInputRow<String>("diseaseName") {
                // Sets disease options
                $0.title = "Doença"
                $0.options = []
                $0.options.append("Dengue")
                $0.options.append("Chikungunya")
                $0.options.append("Zika")
                $0.options.append("Outra")
//                $0.value = $0.options.first
            }.cellUpdate { cell, row in
                if row.value != nil {
                    cell.textLabel?.textColor = .black
                }
            }
            <<< SwitchRow("confirmed") { row in
                row.title = "Confirmado por médico"
            }.cellSetup({ (cell, _) in
                cell.switchControl.setOn(false, animated: false)
            })
    }

    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapFromOccurrence", sender: self)
    }

    @objc func saveOccurrence() {
        // Get values from form
        let symptomsStartForm: DateRow? = self.form.rowBy(tag: "symptomsStart")
        let diseaseNameForm: PickerInputRow<String>? = self.form.rowBy(tag: "diseaseName")
        let confirmedForm: SwitchRow? = self.form.rowBy(tag: "confirmed")
        let locationForm: LocationRow? = self.form.rowBy(tag: "location")

        if let location: CLLocation = locationForm?.value,
            let initialSymptoms: Date = symptomsStartForm?.value,
            let diseaseName: String = diseaseNameForm?.value {

            let dateString = getIso8601Date(from: initialSymptoms)

            let latitude: Double = location.coordinate.latitude
            let longitude: Double = location.coordinate.longitude
            var confirmed: Bool = false
            if let confirmedFormValue = confirmedForm?.value {
                confirmed = confirmedFormValue
            }

            // Create new disease occurrence based on form content
            let newOccurrence = DiseaseOccurrence(diseaseName: diseaseName,
                                                  confirmationStatus: confirmed,
                                                  initialSymptoms: dateString,
                                                  latitude: latitude,
                                                  longitude: longitude)
            // Upload to the API
            DiseaseOccurrencesServices.createDisease(newOccurrence: newOccurrence, { (error) in
                 if error == nil {
                    self.showFeedbackAndUnwind(successful: true)
                 } else {
                    self.showFeedbackAndUnwind(successful: false)
                    print(error!)
                 }
             })
        } else {
            // Shows user feedback that not every mandatory field was filled.
            if locationForm?.value == nil {
                locationForm?.cellUpdate { (cell, row) in
                    if row.value == nil {
                        cell.textLabel?.textColor = .appCoral
                    }
                }
                locationForm?.reload()
                print("No location was set")
            }
            if symptomsStartForm?.value == nil {
                symptomsStartForm?.cellUpdate { (cell, row) in
                    if row.value == nil {
                        cell.textLabel?.textColor = .appCoral
                    }
                }
                symptomsStartForm?.reload()
                print("No symptoms start was set")
            }
            if diseaseNameForm?.value == nil {
                diseaseNameForm?.cellUpdate { (cell, row) in
                    if row.value == nil {
                        cell.textLabel?.textColor = .appCoral
                    }
                }
                diseaseNameForm?.reload()
                print("No disease name was set")
            }

            Utils.setupAlertControllerWithTitle(viewController: self,
                                                title: Messages.formsFailTitle,
                                                message: Messages.formsFailMessage,
                                                systemImage: "xmark.octagon",
                                                color: .appCoral,
                                                timer: nil,
                                                completion: { })
        }
    }

    private func showFeedbackAndUnwind(successful: Bool) {
        if successful {
           DispatchQueue.main.async {
                Utils.setupAlertControllerWithTitle(viewController: self,
                                            title: Messages.createdAssetTitleSuccess2,
                                            message: Messages.newDiseaseOccurrenceMessageSuccess,
                                            systemImage: "checkmark.circle",
                                            color: .appDarkImperialBlue,
                                            timer: nil,
                                            completion: {
                                            self.performSegue(withIdentifier: "unwindToMapFromOccurrence",
                                                              sender: self)
                })
           }
           print("Created disease occurrence successfully.")
        } else {
           DispatchQueue.main.async {
                Utils.setupAlertControllerWithTitle(viewController: self,
                                           title: Messages.failTitle,
                                           message: Messages.failMessage,
                                           systemImage: "xmark.octagon",
                                           color: .appCoral,
                                           timer: nil,
                                           completion: {
                                            self.performSegue(withIdentifier: "unwindToMapFromOccurrence",
                                                              sender: self)
                })
           }
        }
    }
}

func getIso8601Date(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

    let dateString = formatter.string(from: date)
    return dateString
}
