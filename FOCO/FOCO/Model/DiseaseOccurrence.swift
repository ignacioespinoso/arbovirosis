/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Contains the information about the point to be projected at the map
 
*/

import Foundation


class DiseaseOccurrence: Codable {
    
    let id: CLong
    let diseaseName: String
    let latitude: Double
    let longitude: Double
//    let diseaseType: String
//    let creationDate: String
//    let initialDate: String
//    let confirmationStatus: String
    


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case diseaseName = "diseaseName"
        case latitude = "latitude"
        case longitude = "longitude"
//        case diseaseType = "disease_type"
//        case creationDate = "creation_date"
//        case initialDate = "initial_date"
//        case confirmationStatus = "confirmation_status"
    }
}
