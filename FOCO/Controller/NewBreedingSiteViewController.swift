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

    var beedingSiteService = BreedingSitesServices()

    @IBOutlet weak var breedingSiteImage: UIImageView!
    var imagePicker: ImagePicker!

    @IBOutlet weak var portraitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets up image picker view and placeholder image.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        breedingSiteImage.backgroundColor = UIColor.lightGray

        // Sets back button
        let backButton = UIBarButtonItem(title: "Voltar",
                                         style: .plain,
                                         target: self,
                                         action: #selector(back(sender:)))
        self.navigationItem.backBarButtonItem = backButton

        // Sets table view form below the image picker view.
        tableView?.frame = CGRect(x: (self.tableView?.frame.origin.x)!,
                                  y: (self.tableView?.frame.origin.y)!,
                                  width: (self.tableView?.frame.size.width)!,
                                  height: (self.tableView?.frame.size.height)! - 40)

        // Adds done button
        let doneButton = UIBarButtonItem(title: "Pronto",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveOccurrence))

        backButton.tintColor = .appDarkImperialBlue
        doneButton.tintColor = .appDarkImperialBlue

        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = backButton
        self.title = "Novo Foco"

        // Implements form rows
        form +++ Section("Dados do Foco")
            <<< TextRow("title") { row in
                row.title = "Título"
            }
            <<< PickerInputRow<String>("accessType") {
                // Sets disease options
                $0.title = "Forma de Acesso"
                $0.options = []
                $0.options.append("Área Pública")
                $0.options.append("Área Privada")
                $0.options.append("Outro")
            }
            <<< LocationRow("location") {
                $0.title = "Localização"
                $0.value = defaultLocation ?? locationManager.location
            }

            +++ Section("O que está acontecendo nesse local? (opcional)")
            <<< TextAreaRow("description") { row in
                row.title = "Descrição"
                row.placeholder = "Ex. Vi esses pneus jogados na praça e estão com muita água parada por conta da chuva."
        }
    }

    // Show image picker when button is pressed.
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    // Performs segue back to the navigator screen
    @objc func back(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToMapFromBreedingSite", sender: self)
    }

    // Saves breeding site occurrence
    @objc func saveOccurrence() {
        // Retrieves data from the form
        let titleForm: TextRow? = self.form.rowBy(tag: "title")
        let accessTypeForm: PickerInputRow<String>? = self.form.rowBy(tag: "accessType")
        let locationForm: LocationRow? = self.form.rowBy(tag: "location")

        // Verifies if mandatory fields were filled
        if let location = locationForm?.value,
            let title = titleForm?.value,
            let accessType = accessTypeForm?.value {

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            createBreedingSite(title, accessType, latitude, longitude)

        } else {
            showFeedback(locationForm, titleForm, accessTypeForm)

            Utils.setupAlertControllerWithTitle(viewController: self,
                                                title: Messages.formsFailTitle,
                                                message: Messages.formsFailMessage,
                                                systemImage: "xmark.octagon",
                                                color: .appCoral,
                                                timer: nil,
                                                completion: { })
        }
    }

    // Shows an alert controller and dismiss it before unwinding.
    private func showFeedbackAndUnwind(successful: Bool) {
        if successful {
            DispatchQueue.main.async {
                Utils.setupAlertControllerWithTitle(viewController: self,
                                                    title: Messages.createdAssetTitleSuccess,
                                                    message: Messages.newBreedingSiteMessageSuccess,
                                                    systemImage: "checkmark.circle",
                                                    color: .appDarkImperialBlue,
                                                    timer: nil,
                                                    completion: {
                                                        self.performSegue(withIdentifier: "unwindToMapFromBreedingSite",
                                                                          sender: self)
                })
            }
            print("Created breeding site successfully.")
        } else {
            DispatchQueue.main.async {
                Utils.setupAlertControllerWithTitle(viewController: self,
                                                    title: Messages.failTitle,
                                                    message: Messages.failMessage,
                                                    systemImage: "xmark.octagon",
                                                    color: .appCoral,
                                                    timer: nil,
                                                    completion: {
                                                        self.performSegue(withIdentifier: "unwindToMapFromBreedingSite",
                                                                          sender: self)
                })
            }
        }
    }

    // MARK: - Private Methods
     private func checkLocation(_ locationForm: LocationRow?) {
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
    }

    private func showFeedback(_ locationForm: LocationRow?, _ titleForm: TextRow?, _ accessTypeForm: PickerInputRow<String>?) {
        checkLocation(locationForm)
        if titleForm?.value == nil {
            titleForm?.cellUpdate { (cell, row) in
                if row.value == nil {
                    cell.textLabel?.textColor = .appCoral
                }
            }
            titleForm?.reload()
            print("No symptoms start was set")
        }
        if accessTypeForm?.value == nil {
            accessTypeForm?.cellUpdate { (cell, row) in
                if row.value == nil {
                    cell.textLabel?.textColor = .appCoral
                }
            }
            accessTypeForm?.reload()
            print("No access type was set")
        }
    }

    private func createBreedingSite(_ title: String, _ accessType: String, _ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        // Instantiate new breeding site
        let newBreedingSite = BreedingSite(title: title,
                                           description: self.form.rowBy(tag: "description")?.value,
                                           type: accessType,
                                           latitude: latitude,
                                           longitude: longitude)

        // Upload breeding site to the API
        beedingSiteService.createSite(breedingSite: newBreedingSite,
                                         image: self.breedingSiteImage.image) { (error) in
                                            if error == nil {
                                                self.showFeedbackAndUnwind(successful: true)
                                                print("Created breeding site successfully.")
                                            } else {
                                                self.showFeedbackAndUnwind(successful: false)
                                                print(error!)
                                            }
        }
    }
}

// MARK: - ImagePickerDelegate
extension NewBreedingSiteViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        // Adjust placeholder content depending if an image was selected.
        self.breedingSiteImage.image = image
        if breedingSiteImage.image != nil {
            portraitButton.isHidden = true
        } else {
            portraitButton.isHidden = false
        }
    }
}
