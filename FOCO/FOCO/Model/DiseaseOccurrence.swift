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

    init(diseaseName: String, latitude: Double, longitude: Double) {
        // Para efeito de POST, o parâmetro id é irrelevante, mas para init precisa se não
        // Enconder não funciona
        self.id = 1
        self.diseaseName = diseaseName
        self.latitude = latitude
        self.longitude = longitude
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case diseaseName = "diseaseName"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
