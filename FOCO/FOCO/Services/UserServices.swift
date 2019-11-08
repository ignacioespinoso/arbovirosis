/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Services Layer. Independent from adopted database
 
Error Handling + doing aditional treatment to data
 
*/

import UIKit

class UserServices {

    static func getAllUsers(_ completion: @escaping (_ errorMessage: Error?, _ user: User?) -> Void) {
        
        // tratamento de erros?
        
        UserDAO.findAll { (error, user) in
            
            if error != nil {
                //Handle errors
            } else {
                completion(nil,user)
            }
        }
        
    }

}
