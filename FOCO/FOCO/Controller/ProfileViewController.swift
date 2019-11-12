/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Main ViewController
 
*/

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    fileprivate var points: [DiseaseOccurrence]?
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
        
//        print(self.points!)
//
//        if let point = self.points {
//            if iterator < point.count {
//                self.labelName.text = point[iterator].diseaseName
//                iterator += 1
//            }
//        }


        let jsonObject: [String: Any] = [
            "id": 10,
            "diseaseName":"POST",
            "latitude":-22.81673,
            "longitude":-47.09485
        ]

       print(JSONSerialization.isValidJSONObject(jsonObject))
        var jsonData: Data? = nil

       do {
            jsonData = try NSKeyedArchiver.archivedData(withRootObject: jsonObject, requiringSecureCoding: false)
        } catch let myJSONError {
            print(myJSONError)
        }


        DiseaseOccurrencesDAO.create(jsonData: jsonData, { (error, data) in


                        if data != nil {
                            self.points = data
                        } else {
                            print(error.debugDescription)
                        }

            
            

        })
    }











}

