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

//        BreedingSitesServices.getAllSites { (errorMessage, points) in
//            if points != nil {
//                self.points = points
//                print(points!)
//            } else {
//                print(errorMessage.debugDescription)
//            }
//        }
    }

    // MARK: - Functions

    @IBAction func updateLabekl(_ sender: Any) {

        let jsonObject = BreedingSite(title: "Pneuzin",
                                      description: "vai que vai",
                                      type: "Descarte",
                                      latitude: -22.81277,
                                      longitude: -47.06107)

        BreedingSitesServices.createSite(breedingSite: jsonObject, image: nil, { (error) in
            if error == nil {
                print("TUDO CERRTO")
            } else {
                print(error!)
            }
        })
    }

}
