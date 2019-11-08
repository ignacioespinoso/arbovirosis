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
    let pass: String
    let name: String
    let profession: String
    let bio: String
    let picture: String
    let member_since: String
    
}
