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

    init(diseaseName: String, latitude: Double, longitude: Double) {
        // Para efeito de POST, o parâmetro id precisa ser 0
        self.id = 0
        self.diseaseName = diseaseName
        self.latitude = latitude
        self.longitude = longitude
    }

}
