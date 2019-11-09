/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session
 
Because its Asynchronous, escaping completion blocks are used
 
*/

import Foundation

class HerokuAPIDAO {
    
    static let address = URL(string: "https://safe-peak-03441.herokuapp.com/diseases")
    
    // MARK: -  functions
    
    static func findAll (_ completion: @escaping (_ error: Error?, _ user: [HerokuAPI]?) -> Void) {
        
        if let url = address {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let data = data {
                    do {
                        let user = try JSONDecoder().decode([HerokuAPI].self, from: data)
                        // único caso onde não há erro. Passo para frente o user
                        completion(nil, user)
                    } catch let error {
                        completion(error, nil)
                        print(error.localizedDescription)
                    }
                }
                
            }
            
            // resume faz o request acontecer
            task.resume()
        }
        
    }
    
}
