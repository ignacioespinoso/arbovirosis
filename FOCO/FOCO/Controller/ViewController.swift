/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Main ViewController
 
*/

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    fileprivate var points: [HerokuAPI]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        HerokuAPIServices.getAllHero { (errorMessage, points) in
            if points != nil {
                self.points = points
            } else {
                print(errorMessage.debugDescription)
            }
            
        }
        
        
    }

    @IBAction func updateLabekl(_ sender: Any) {
        
        print(self.points)
        
        if let point = self.points {
            self.labelName.text = point[0].name
        }
    }
    
}

