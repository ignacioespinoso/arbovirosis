/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Class used to test the HerokuAPI
 
*/


import Foundation

class HerokuAPI: Codable {
    
    let id: Int
    let name: String
    let lat: Int
    let lon: Int

    
    enum CodingKeys: String, CodingKey {
        case lat = "latitude"
        case lon = "longitude"
    }
    
}
