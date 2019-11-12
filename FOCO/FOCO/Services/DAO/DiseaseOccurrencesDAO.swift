/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data Access Object for URL request

*/

import Foundation

class DiseaseOccurrencesDAO {
    
    static let address = URL(string: "https://safe-peak-03441.herokuapp.com/diseases")
    
    // MARK: -  functions
    
    static func findAll (_ completion: @escaping (_ error: Error?, _ user: [DiseaseOccurrence]?) -> Void) {
        
        if let url = address {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let data = data {
                    do {
                        let occurrence = try JSONDecoder().decode([DiseaseOccurrence].self, from: data)
                        // único caso onde não há erro. Passo para frente a ocorrencia
                        completion(nil, occurrence)
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
