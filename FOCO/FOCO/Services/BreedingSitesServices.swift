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
                print(error.debugDescription)
            } else {
                completion(nil, site)
            }
        }
    }

    // MARK: - Post

    // Apenas precisa checar erro, o objeto retornado é o próprio enviado.
    // Checar http status
    static func createSite (jsonData: Data?, _ completion: @escaping (_ error: Error?) -> Void) {

        BreedingSitesDAO.create(jsonData: jsonData, { (error) in

            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print("DEU RUIMMM")
                print(error.debugDescription)
            } else {
                completion(error)
            }
        })
    }

}
