/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Services Layer. Independent from adopted database
Error Handling + doing aditional treatment to data

*/

import Foundation

import UIKit

class DiseaseOccurrencesServices {

    // MARK: - Get

    static func getAllDiseases(_ completion: @escaping (_ errorMessage: Error?,
                                                        _ ocurrence: [DiseaseOccurrence]?) -> Void) {

        // Falta fazer tratamento de erros - baixa prioridade
        DiseaseOccurrencesDAO.findAll { (error, ocurrence) in

            if error != nil {
                // Handle errors - mensagem mais amigável para usuário
                print(error.debugDescription)
                completion(error, nil)
            } else {
                completion(nil, ocurrence)
            }
        }
    }

    // MARK: - Post

    // Apenas precisa checar erro, o objeto retornado é o próprio enviado.
    // Checar http status
    static func createDisease (newOccurrence: DiseaseOccurrence, _ completion: @escaping (_ error: Error?) -> Void) {
        var jsonData: Data?
        do {
            jsonData = try JSONEncoder().encode(newOccurrence)
        } catch let myJSONError {
            completion(myJSONError)
        }

        DiseaseOccurrencesDAO.create(jsonData: jsonData, { (error) in
            if error != nil {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
}
