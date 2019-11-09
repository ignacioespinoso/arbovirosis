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

    enum CodingKeys: String, CodingKey {
        case id = "id_teste"
        case login = "log"
    }
    
}
