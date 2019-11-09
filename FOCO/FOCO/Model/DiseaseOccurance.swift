/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Contains the information about the point to be projected at the map
 
*/

import Foundation


class DiseaseOccurance: Codable {

    let diseaseType: String
    let creationDate: String
    let initialDate: String
    let patientName: String
    let confirmationStatus: String
    let lat: String
    let lon: String


    enum CodingKeys: String, CodingKey {
        case diseaseType = "disease_type"
        case creationDate = "creation_date"
        case initialDate = "initial_date"
        case patientName = "patient_name"
        case confirmationStatus = "confirmation_status"
        case lat = "lat"
        case lon = "lon"
    }
}
