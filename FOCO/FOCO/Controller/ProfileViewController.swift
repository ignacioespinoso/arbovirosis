/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Main ViewController
 
*/

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    fileprivate var points: [BreedingSite]?
    var iterator: Int = 0

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        BreedingSitesServices.getAllSites { (errorMessage, points) in
            if points != nil {
                self.points = points
                print(points!)
            } else {
                print(errorMessage.debugDescription)
            }
        }
    }

    // MARK: - Functions

    @IBAction func updateLabekl(_ sender: Any) {

        let jsonObject = DiseaseOccurrence(diseaseName: "postTeste", latitude: -22.81552, longitude: -47.094)

        var jsonData: Data?

       do {
            jsonData = try JSONEncoder().encode(jsonObject)
        } catch let myJSONError {
            print(myJSONError)
        }

        print(jsonData!)

        DiseaseOccurrencesServices.createDisease(jsonData: jsonData, { (error) in

            if error == nil {
                print("TUDO CERRTO@")
            } else {
                print(error!)
            }

        })

    }

}
