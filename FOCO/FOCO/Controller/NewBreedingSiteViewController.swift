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
    var defaultLocation: CLLocation?

    @IBOutlet weak var breedingSiteImage: UIImageView!
    var imagePicker: ImagePicker!

    @IBOutlet weak var portraitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets up image picker view and placeholder image.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        breedingSiteImage.backgroundColor = UIColor.lightGray

        // Sets back button
        let backButton = UIBarButtonItem(title: "Novo Foco", style: .plain,
                                         target: self, action: #selector(back(sender:)))
        self.navigationItem.backBarButtonItem = backButton

        // Sets table view form below the image picker view.
        tableView?.frame = CGRect(x: (self.tableView?.frame.origin.x)!,
                                 y: (self.tableView?.frame.origin.y)!,
                                 width: (self.tableView?.frame.size.width)!,
                                 height: (self.tableView?.frame.size.height)! - 40)
        
        // Adds done button
        let doneButton = UIBarButtonItem(title: "Pronto", style: .done,
                                         target: self, action: #selector(saveOccurrence))
        self.navigationItem.rightBarButtonItem = doneButton
        self.title = "Novo Foco"
        form +++ Section("Dados do Foco")
            <<< TextRow("title") { row in
                row.title = "Título"
            }
            <<< PickerInputRow<String>("accessType") {
                // Sets disease options
                $0.title = "Tipo de Acesso"
                $0.options = []
                $0.options.append("Público")
                $0.options.append("Privado")
                $0.options.append("Outro")
            }
            <<< LocationRow("location") {
                $0.title = "Localização"
                $0.value = defaultLocation
            }

        +++ Section("Descrição (opcional)")
            <<< TextAreaRow("description") { row in
                row.title = "Descrição"
                row.placeholder = "Conte para nós mais detalhes"
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
        let accessTypeForm: PickerInputRow<String>? = self.form.rowBy(tag: "accessType")
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
//            Alamofire.request("https://safe-peak-03441.herokuapp.com/breeding-sites/5/?file",
//            method: .patch, parameters: params as Parameters)

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
        if breedingSiteImage.image != nil {
            portraitButton.isHidden = true
        } else {
            portraitButton.isHidden = false
        }
    }
}
