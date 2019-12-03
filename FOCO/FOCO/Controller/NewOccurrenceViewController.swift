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

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Voltar", style: .plain,
                                         target: self, action: #selector(back(sender:)))

        self.navigationItem.backBarButtonItem = backButton
        let doneButton = UIBarButtonItem(title: "Pronto", style: .done,
                                         target: self, action: #selector(saveOccurrence))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.title = "Nova Ocorrência"

        // Defines form row and cells
        form +++ Section("Dados do Paciente")
            <<< DateRow("symptomsStart") { row in
                row.title = "Início dos sintomas*"
            }.cellSetup({ (cell, _) in
                cell.datePicker.locale = Locale(identifier: "pt_BR")
            })

        +++ Section(header: "Informações do Caso",
                    footer: "Informe para diferenciarmos suspeitas de casos confirmados.\n\n* - Obrigatório")
            <<< PickerInputRow<String>("diseaseName") {
                // Sets disease options
                $0.title = "Doença"
                $0.options = []
                $0.options.append("Dengue")
                $0.options.append("Chikungunya")
                $0.options.append("Zika")
                $0.options.append("Outra")
                $0.value = $0.options.first
            }
            <<< SwitchRow("confirmed") { row in
                row.title = "Confirmado por médico*"
            }.cellSetup({ (cell, _) in
                cell.switchControl.setOn(false, animated: false)
            })
            <<< LocationRow("location") {
                $0.title = "Localização*"
                $0.value = locationManager.location
            }
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
            let initialSymptoms: Date = symptomsStartForm?.value {

            let dateString = getIso8601Date(from: initialSymptoms)

            let latitude: Double = location.coordinate.latitude
            let longitude: Double = location.coordinate.longitude
            let diseaseName: String? = diseaseNameForm?.value
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
            var jsonData: Data?
            do {
                 jsonData = try JSONEncoder().encode(newOccurrence)
             } catch let myJSONError {
                 print(myJSONError)
             }

             print(jsonData!)

             DiseaseOccurrencesServices.createDisease(jsonData: jsonData, { (error) in
                 if error == nil {
                     print("TUDO CERRTO")
                 } else {
                     print(error!)
                 }
             })
            performSegue(withIdentifier: "unwindToMapFromOccurrence", sender: self)
        } else {
            if locationForm?.value == nil {
                print("no location set")
            }
            if symptomsStartForm?.value == nil {
                print("no start set")
            }
            let alert = UIAlertController(title: "Erro",
                                          message: "Preencha os campos obrigatórios",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
