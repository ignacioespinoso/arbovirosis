/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Services Layer. Independent from adopted database
 
Error Handling + doing aditional treatment to data
 
*/

import UIKit

class HerokuAPIServices {

    static func getAllHero(_ completion: @escaping (_ errorMessage: Error?, _ hero: [HerokuAPI]?) -> Void) {
        
        // tratamento de erros?
        // Falta fazer - baixa prioridade
        
        HerokuAPIDAO.findAll { (error, hero) in
            
            if error != nil {
                //Handle errors - mensagem mais amigável para usuário
                print(error.debugDescription)
            } else {
                completion(nil,hero)
            }
        }
        
    }

}
