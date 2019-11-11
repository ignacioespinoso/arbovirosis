//
//  DiseaseOccurrencesDAO.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 11/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

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
