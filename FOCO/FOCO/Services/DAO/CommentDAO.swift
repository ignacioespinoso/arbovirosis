//
//  CommentDAO.swift
//  FOCO
//
//  Created by Beatriz Viseu Linhares on 04/12/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation

class CommentDAO {

    // MARK: - Get Comment Array

    static func findAllCommentsByBreedingSiteId (breedingSiteId: Int,
                                                 _ completion: @escaping (_ error: Error?,
                                                                            _ site: [Comment]?) -> Void) {

        let urlString = "https://safe-peak-03441.herokuapp.com/breeding-sites/\(breedingSiteId)/comments"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                if let data = data {
                    do {
                        let site = try JSONDecoder().decode([Comment].self, from: data)
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

    // MARK: - Post Comment

    static func createComment (breedingSiteId: Int,
                               jsonData: Data?,
                               _ completion: @escaping (_ error: Error?,
                                                        _ commentId: Int?) -> Void) {

        let urlString = "https://safe-peak-03441.herokuapp.com/breeding-sites/\(breedingSiteId)/comments"

        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode)
                else {
                    print("Server error! Comment!")
                    completion(error, nil)
                    return
                }

                // Checking if error is empty
                if let error = error {
                    print("Error!")
                    completion(error, nil)
                    return
                }

                print("Create Comment response status", response.statusCode)

                if let data = data {
                        print("data=\(String(data: data, encoding: .utf8))")
                        let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                        let commentId = Int.init(stringInt ?? "")
                        completion(nil, commentId)
                        print("Json Decoder post Comment ok!")
                }
            }
            task.resume()
        }
    }

    // MARK: - Report Comment

    static func reportComment (breedingSiteId: Int,
                               commentId: Int,
                               _ completion: @escaping (_ error: Error?,
                                                        _ reports: Int?) -> Void) {

        let urlString = "https://safe-peak-03441.herokuapp.com/breeding-sites/\(breedingSiteId)/comments/\(commentId)/report"

        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode)
                else {
                    print("Server error! Report Comment!")
                    print(error.debugDescription)
                    completion(error, nil)
                    return
                }

                // Checking if error is empty
                if let error = error {
                    print("Error!")
                    completion(error, nil)
                    return
                }

                print("Report Comment response status", response.statusCode)

                if let data = data {
                        print("data=\(String(data: data, encoding: .utf8))")
                        let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                        let reports = Int.init(stringInt ?? "")
                        completion(nil, reports)
                        print("Json Decoder Report Comment ok!")
                }
            }
            task.resume()
        }
    }
}
