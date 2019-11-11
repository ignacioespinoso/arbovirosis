//
//  DiseaseOcurrencesServices.swift
//  FOCO
//
//  Created by Ignácio Espinoso Ribeiro on 11/11/19.
//  Copyright © 2019 arbovirosis. All rights reserved.
//

import Foundation

import UIKit

class DiseaseOccurrencesServices {

    static func getAllDiseases(_ completion: @escaping (_ errorMessage: Error?, _ disease: [DiseaseOccurrence]?) -> Void) {
        
        // tratamento de erros?
        // Falta fazer - baixa prioridade
        
        DiseaseOccurrencesDAO.findAll { (error, disease) in
            
            if error != nil {
                //Handle errors - mensagem mais amigável para usuário
                print(error.debugDescription)
            } else {
                completion(nil,disease)
            }
        }
        
    }

}
