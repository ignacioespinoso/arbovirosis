/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Data access object. Perform the URL session

*/

import Foundation
import UIKit
import Alamofire

protocol BreedingSitesDAO {
    func createBreedingSite (jsonData: Data?, _ completion: @escaping (_ error: Error?, _ siteId: Int?) -> Void)
    func findAll (_ completion: @escaping (_ error: Error?,
                                            _ site: [BreedingSite]?) -> Void)
    func findById (breedingId: Int, _ completion: @escaping (_ error: Error?,
                                                            _ site: BreedingSite?) -> Void)
    func getImageById (breedingId: Int, _ completion: @escaping (_ error: Error?,
                                                                _ image: [UInt8]?) -> Void)
    func uploadImageById (breedingId: Int,
                          image: UIImage,
                          _ completion: @escaping (_ error: Error?) -> Void)

    func reportSite (breedingSiteId: Int, completion: @escaping (_ error: Error?,
                                                                    _ reports: Int?) -> Void)
}
    

class BreedingSitesWebDAO: BreedingSitesDAO {
    let address = URL(string: productionUrlBreedingSites)

    // MARK: - Find

    func findAll (_ completion: @escaping (_ error: Error?,
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

    func findById (breedingId: Int, _ completion: @escaping (_ error: Error?,
                                                  _ site: BreedingSite?) -> Void) {
        if let url = URL(string: productionUrlBreedingSites + "\(breedingId)") {
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

                if let data = data {
                    do {
                        let site = try JSONDecoder().decode(BreedingSite.self, from: data)
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

    // MARK: - Find Image By Id

    func getImageById (breedingId: Int, _ completion: @escaping (_ error: Error?,
                                                  _ image: [UInt8]?) -> Void) {

        if let url = URL(string: productionUrlBreedingSites +  "\(breedingId)/pic") {

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

    // MARK: - Upload Image
    func uploadImageById (breedingId: Int,
                                 image: UIImage,
                                 _ completion: @escaping (_ error: Error?) -> Void) {
        if let url = URL(string: productionUrlBreedingSites + "\(breedingId)") {
            Alamofire.upload(multipartFormData: { MultipartFormData in
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    MultipartFormData.append(imageData,
                                             withName: "file",
                                             fileName: prodFirebaseFilename,
                                             mimeType: "image/jpeg")
                }
            }, to: url,
               method: .patch,
               headers: ["Content-Type": "multipart/form-data"]) { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        guard response.result.isSuccess else {
                            print(response.error?.localizedDescription ?? "Error while requesting")
                            return
                        }
                        if let value = response.result.value {
                            print(value)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    // MARK: - Create

    func createBreedingSite (jsonData: Data?, _ completion: @escaping (_ error: Error?,
                                                                            _ siteId: Int?) -> Void) {

        if let url = self.address {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode)
                else {
                    print("Server error! Breeding Site")
                    completion(error, nil)
                    return
                }

                // Checking if error is empty
                if let error = error {
                    print("Error!")
                    completion(error, nil)
                    return
                }

                print("Create Site response status", response.statusCode)

                if let data = data {
                        print("data=\(String(data: data, encoding: .utf8) ?? "String interpolation did not work")")
                        // Único caso onde não há erro. Não passo erro para frente
                        let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                        let siteId = Int.init(stringInt ?? "")
                        completion(nil, siteId)
                        print("Json Decoder post Site ok!")
                }
            }
            task.resume()
        }
    }

    // MARK: - Report Breeding Site

    func reportSite (breedingSiteId: Int,
                     completion: @escaping (_ error: Error?,
                                            _ reports: Int?) -> Void) {

        let urlString = productionUrlBreedingSites + "\(breedingSiteId)/report"

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

                print("Report Site response status", response.statusCode)

                if let data = data {
                    print("data=\(String(describing: String(data: data, encoding: .utf8)))")
                        let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                        let reports = Int.init(stringInt ?? "")
                        completion(nil, reports)
                        print("Json Decoder Report Site ok!")
                }
            }
            task.resume()
        }
    }
}
