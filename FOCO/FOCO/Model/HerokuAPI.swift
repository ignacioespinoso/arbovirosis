/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Class used to test the HerokuAPI
 
*/


import Foundation

class HerokuAPI: Codable {
    
    let id: Int
    let name: String
    let lat: Double
    let lon: Double

    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case lat = "latitude"
        case lon = "longitude"
    }
    
}
