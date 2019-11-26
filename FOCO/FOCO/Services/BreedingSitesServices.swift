/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Services Layer. Independent from adopted database
Error Handling + doing aditional treatment to data

*/

import Foundation

import UIKit

class BreedingSitesServices {

    // MARK: - Get

    static func getAllSites(_ completion: @escaping (_ errorMessage: Error?,
                                                     _ site: [BreedingSite]?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        BreedingSitesDAO.findAll { (error, site) in

            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("Unable to retrieve all breeding sites.")
                print(error.debugDescription)
            } else {
                completion(nil, site)
            }
        }
    }

    static func getSiteById(breedingId: Int, _ completion: @escaping (_ errorMessage: Error?,
                                                     _ site: BreedingSite?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        BreedingSitesDAO.findById(breedingId: breedingId, { (error, site) in

            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("Unable to retrieve breeding site.")
                print(error.debugDescription)
            } else {
                completion(nil, site)
            }
        })
    }

    // MARK: - Get Breeding Image
    static func getImageById(breedingId: Int, _ completion: @escaping (_ error: Error?,
                                                        _ image: [UInt8]?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        BreedingSitesDAO.getImageById(breedingId: breedingId, { (error, image) in
            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("Unable to retrieve breeding site image.")
                print(error.debugDescription)
            } else {
                completion(nil, image)
            }
        })
    }

    // MARK: - Post

    // Apenas precisa checar erro, o objeto retornado é o próprio enviado.
    // Checar http status
    static func createSite (breedingSite: BreedingSite,
                            image: UIImage?,
                            _ completion: @escaping (_ error: Error?) -> Void) {
        var jsonData: Data?
        do {
             jsonData = try JSONEncoder().encode(breedingSite)
        } catch let myJSONError {
             print(myJSONError)
        }

        BreedingSitesDAO.createBreedingSite(jsonData: jsonData, { (error, siteId) in

            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("Unable to create breeding site.")
                print(error.debugDescription)
                completion(error)
            } else {
                if let id = siteId, let image = image {
                    BreedingSitesServices.uploadImage(toBreedingSiteId: id, image: image, { (uploadError) in
                        if let uploadImageError = uploadError {
                            print("Error uploading image.")
                            print(uploadImageError)
                        } else {
                            print("ok")
                        }
                    })
                    completion(nil)
                } else {
                    print("No image was uploaded.")
                }
            }
        })
    }

    // MARK: - Patch
    static func uploadImage(toBreedingSiteId: Int, image: UIImage,
                            _ completion: @escaping (_ error: Error?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        BreedingSitesDAO.uploadImageById(breedingId: toBreedingSiteId, image: image, { (error) in
            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("Unable to upload breeding site image.")
                print(error.debugDescription)
            } else {
                completion(error)
            }
        })
    }
}
