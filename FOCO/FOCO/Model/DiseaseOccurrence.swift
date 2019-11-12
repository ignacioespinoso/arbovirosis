/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Contains the information about the point to be projected at the map
 
*/

import Foundation


struct DiseaseOccurrence: Codable {
    
    let id: CLong
    let diseaseName: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case diseaseName = "diseaseName"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
