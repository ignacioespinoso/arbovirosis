/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Main ViewController
 
*/

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    fileprivate var points: DiseaseOccurrence?
    var iterator: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

//        DiseaseOccurrencesServices.getAllDiseases { (errorMessage, points) in
//            if points != nil {
//                self.points = points
//            } else {
//                print(errorMessage.debugDescription)
//            }
//
//        }

    }

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
