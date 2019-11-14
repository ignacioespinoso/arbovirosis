/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Contains the information about the breeding site on the map

*/

import Foundation

struct BreedingSite: Codable {

    let id: CLong
    let title: String
    let description: String
    let type: String
    let created: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case type = "type"
        case created = "created"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(title: String, description: String, type: String, created: String,
         latitude: Double, longitude: Double) {
        // Para efeito de POST, o parâmetro id precisa ser 0
        self.id = 0
        self.title = title
        self.description = description
        self.type = type
        self.created = created
        self.latitude = latitude
        self.longitude = longitude
    }

}
