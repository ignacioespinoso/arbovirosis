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
        form +++ Section("Dados do Paciente")
            <<< DateRow("symptomsStart") { row in
                row.title = "Início dos sintomas*"
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "pt_BR")
                row.dateFormatter = formatter
            }.cellSetup({ (cell, _) in
                cell.datePicker.locale = Locale(identifier: "pt_BR")
            })

        +++ Section(header: "Informações do Caso",
                    footer: "Informe para diferenciarmos suspeitas de casos confirmados.\n\n* - Obrigatório")
            <<< TextRow("diseaseName") { row in
                row.title = "Doença"
            }
            <<< SwitchRow("confirmed") { row in
                row.title = "Confirmado por médico*"
            }
            <<< LocationRow("location") {
                $0.title = "Localização*"
                $0.value = locationManager.location
            }
    }

    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapFromOccurrence", sender: self)
    }

    @objc func saveOccurrence() {
//        let symptomsStartForm: TextRow? = self.form.rowBy(tag: "symptomsStart")
        let diseaseNameForm: TextRow? = self.form.rowBy(tag: "diseaseName")
//        let confirmedForm: TextRow? = self.form.rowBy(tag: "confirmed")
        let locationForm: LocationRow? = self.form.rowBy(tag: "location")

        if let location = locationForm?.value as? CLLocation, let name = diseaseNameForm?.value as? String {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

//            let symptomsStart = symptomsStartForm?.value as? Date
//            let confirmed = confirmedForm?.value as? Bool

            let newOccurrence = DiseaseOccurrence(diseaseName: name, latitude: latitude, longitude: longitude)

            print(newOccurrence)
            performSegue(withIdentifier: "unwindToMapFromOccurrence", sender: self)
        } else {
            let alert = UIAlertController(title: "Erro", message: "Preencha os campos obrigatórios", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
