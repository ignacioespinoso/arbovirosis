/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session

*/

import Foundation

class BreedingSitesDAO {

    static let address = URL(string: "https://safe-peak-03441.herokuapp.com/breeding-sites/")

    // MARK: - Functions

    static func findAll (_ completion: @escaping (_ error: Error?,
                                                  _ site: [BreedingSite]?) -> Void) {

        if let url = address {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                if let data = data {
                    do {
                        let site = try JSONDecoder().decode([BreedingSite].self, from: data)
                        // único caso onde não há erro. Passo para frente a ocorrencia
                        completion(nil, site)
                    } catch let error {
                        completion(error, nil)
                        print(error.localizedDescription)
                    }
                }
            }
            // Resume faz o request acontecer
            task.resume()
        }
    }

}
