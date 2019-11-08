/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:

 
*/

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelName: UILabel!
    fileprivate var users: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserServices.getAllUsers { errorMessage, user in
        
        // Aqui é bom criar uma camada a mais, no caso o userServices, mas só para testes colocamos DAO direto
        
        UserDAO.findAll { (errorMessage, user) in
            if user != nil {
                self.users = user
            }else{
                print(errorMessage.debugDescription)
            }
        }
        
        
    }

    @IBAction func updateLabekl(_ sender: Any) {
        
        print(self.users)
        
        if let user = self.users {
            self.labelName.text = user.login
        }
    }
    
}

