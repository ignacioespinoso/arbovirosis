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

class NewBreedingSiteViewController: FormViewController {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Novo Foco", style: .plain,
                                         target: self, action: #selector(back(sender:)))

        self.navigationItem.backBarButtonItem = backButton
        let doneButton = UIBarButtonItem(title: "Pronto", style: .done,
                                         target: self, action: #selector(saveOccurrence))
//        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.title = "Novo Foco"
        form +++ Section(header: "Dados do Foco",
                         footer: "* - Obrigatório")
            <<< TextRow("title") { row in
                row.title = "Título*"
            }
            <<< TextRow("accessType") { row in
                row.title = "Tipo de Acesso*"
            }
            <<< LocationRow("location") {
                $0.title = "Localização*"
                $0.value = locationManager.location
            }

        +++ Section("Descrição")
            <<< TextAreaRow("description") { row in
                row.title = ""
            }
    }

    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapFromBreedingSite", sender: self)
    }

    @objc func saveOccurrence() {
        let titleForm: TextRow? = self.form.rowBy(tag: "title")
        let accessTypeForm: TextRow? = self.form.rowBy(tag: "accessType")
        let locationForm: LocationRow? = self.form.rowBy(tag: "location")

        if let location = locationForm?.value as? CLLocation,
            let title = titleForm?.value as? String,
            let accessType = accessTypeForm?.value as? String {

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            let newBreedingSite = BreedingSite(title: title,
                                               description: "",
                                               type: accessType,
                                               created: "",
                                               latitude: latitude,
                                               longitude: longitude)
            print(newBreedingSite)
            performSegue(withIdentifier: "unwindToMapFromBreedingSite", sender: self)
        } else {
            let alert = UIAlertController(title: "Erro",
                                          message: "Preencha os campos obrigatórios",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
