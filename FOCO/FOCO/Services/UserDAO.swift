/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session
 
Because its Asynchronous, escaping completion blocks are used
 
*/

import Foundation


// Adicionar array de users e nao user



class UserDAO {
    
    static let address = URL(string: "https://api.myjson.com/bins/17gduc")
    // https://safe-peak-03441.herokuapp.com/diseases
    
    // MARK: -  functions
    
    static func findAll (_ completion: @escaping (_ error: Error?, _ user: User?) -> Void) {
        
        if let url = address {
            URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let data = data {
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        // único caso onde não há erro. Passo para frente o user
                        completion(nil, user)
                    } catch let error {
                        completion(error, nil)
                        print(error.localizedDescription)
                    }
                }
                
            }
            
        }
        
    }
        
    
    
}

/*  PARA TRATAMENTO DOS ERROS
 
 if error != nil || data == nil {
     print("Client error!")
     completion(error, nil)
     return
 }

 guard let response = response as? HTTPURLResponse,
           (200...299).contains(response.statusCode)
 else {
     print("Server error!")
     completion(error, nil)
     return
 }

 guard let mime = response.mimeType, mime == "application/json" else {
     print("Wrong MIME type!")
     completion(error, nil)
     return
 }
 */
