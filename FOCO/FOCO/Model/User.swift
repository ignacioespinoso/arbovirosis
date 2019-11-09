/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
All Users from the app are Users objects
 
Codable: Json Parser can fill the User object automatically
 
*/

import Foundation

class User: Codable {
    
    let id: Int
    let login: String

    

//    ai deixar igual api do herolu
//    deixar o coding keys
//    E AI FAZER A CAMADA DE SERVICES PRA CIMA É ISSO. VRAU.
    
    enum CodingKeys: String, CodingKey {
        case id = "id_teste"
        case login = "log"
    }
    
}

/*
 {
   "id": 1234,
   "login": "joao@joao.com",
   "pass": "zxcv",
   "name": "Joao das Neves",
   "profession": "Programador",
   "bio": "De Campinas, trabalha no Eldorado",
   "picture": "hhtp://aqui.com",
   "member_since": "20/10/2019"
 }
 */
