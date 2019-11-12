/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Services Layer. Independent from adopted database

Error Handling + doing aditional treatment to data

*/

import Foundation

import UIKit

class DiseaseOccurrencesServices {

    static func getAllDiseases(_ completion: @escaping (_ errorMessage: Error?, _ ocurrence: [DiseaseOccurrence]?) -> Void) {
        
        // tratamento de erros?
        // Falta fazer - baixa prioridade
        
        DiseaseOccurrencesDAO.findAll { (error, ocurrence) in
            
            if error != nil {
                //Handle errors - mensagem mais amigável para usuário
                print(error.debugDescription)
            } else {
                completion(nil, ocurrence)
            }
        }
        
    }

}
