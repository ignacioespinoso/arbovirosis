/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session

*/

import Foundation

class BreedingSitesDAO {

    static let address = URL(string: "https://safe-peak-03441.herokuapp.com/breeding-sites/")

    // MARK: - Find

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

    // MARK: - Find Image By ID

    static func getImageByID (breedingID: CLong, _ completion: @escaping (_ error: Error?,
                                                  _ image: [UInt8]?) -> Void) {

        if let url = URL(string: "https://safe-peak-03441.herokuapp.com/breeding-sites/\(breedingID)/pic") {

            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                if error != nil {
                    completion(error, nil)
                    print(error?.localizedDescription as Any)
                } else if let data = data {
                    let array = [UInt8](data)
                    completion(nil, array)
                }

            }

            task.resume()
        }
    }


    // MARK: - Create

    static func create (jsonData: Data?, _ completion: @escaping (_ error: Error?) -> Void) {

        if let url = address {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode)
                else {
                    print("Server error! Breeding Site")
                    completion(error)
                    return
                }
                print("Create Site response status", response.statusCode)

                if let data = data {
                    do {
                        _ = try JSONDecoder().decode(BreedingSite.self, from: data)
                        // Único caso onde não há erro. Não passo erro para frente
                        completion(nil)
                        print("Json Decoder post Site ok!")
                    } catch let error {
                        completion(error)
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
}
