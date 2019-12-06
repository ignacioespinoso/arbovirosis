/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session
Because its Asynchronous, escaping completion blocks are used

*/

import Foundation

class DiseaseOccurrencesDAO {

    static let address = URL(string: productionUrlDiseaseOccurrences)

// MARK: Functions
    static func findAll (_ completion: @escaping (_ error: Error?,
                                                  _ occurrence: [DiseaseOccurrence]?) -> Void) {

        if let url = address {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

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
            // Resume faz o request acontecer
            task.resume()
        }
    }

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
                        _ = try JSONDecoder().decode(DiseaseOccurrence.self, from: data)
                        // Único caso onde não há erro. Não passo erro para frente
                        completion(nil)
                        print("Json Decoder post disease ok!")
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
