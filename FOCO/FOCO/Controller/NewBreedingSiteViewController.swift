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
import Alamofire
import AlamofireImage

class NewBreedingSiteViewController: FormViewController {

    let locationManager = CLLocationManager()

    @IBOutlet weak var breedingSiteImage: UIImageView!
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let backButton = UIBarButtonItem(title: "Novo Foco", style: .plain,
                                         target: self, action: #selector(back(sender:)))

        self.navigationItem.backBarButtonItem = backButton

        tableView?.frame = CGRect(x: (self.tableView?.frame.origin.x)!,
                                 y: (self.tableView?.frame.origin.y)!,
                                 width: (self.tableView?.frame.size.width)!,
                                 height: (self.tableView?.frame.size.height)! - 40)

        let doneButton = UIBarButtonItem(title: "Pronto", style: .done,
                                         target: self, action: #selector(saveOccurrence))

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

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapFromBreedingSite", sender: self)
    }

    @objc func saveOccurrence() {
        let titleForm: TextRow? = self.form.rowBy(tag: "title")
        let accessTypeForm: TextRow? = self.form.rowBy(tag: "accessType")
        let locationForm: LocationRow? = self.form.rowBy(tag: "location")

        if let location = locationForm?.value,
            let title = titleForm?.value,
            let accessType = accessTypeForm?.value {

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            let newBreedingSite = BreedingSite(title: title,
                                               description: self.form.rowBy(tag: "description")?.value,
                                               type: accessType,
                                               latitude: latitude,
                                               longitude: longitude)
            print(newBreedingSite)

            // TODO: Create Site should pass BreedingSite object instead of a Data object [Guga]

            BreedingSitesServices.createSite(breedingSite: newBreedingSite,
                                             image: self.breedingSiteImage.image, { (error) in
                 if error == nil {
                    print("Created breeding site successfully.")
                 } else {
                     print(error!)
                 }
            })
            self.performSegue(withIdentifier: "unwindToMapFromBreedingSite", sender: self)

            // TODO: Get ID from createSite responde (probably on DAO, not here) and create Patch Request
            // Tests for ID  5 only -- didn't work
//            let image = breedingSiteImage.image?.pngData()
//            let params = ["file": image ]
//            Alamofire.request("https://safe-peak-03441.herokuapp.com/breeding-sites/5/?file", method: .patch, parameters: params as Parameters)

        } else {
            let alert = UIAlertController(title: "Erro",
                                          message: "Preencha os campos obrigatórios",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension NewBreedingSiteViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.breedingSiteImage.image = image
    }
}
