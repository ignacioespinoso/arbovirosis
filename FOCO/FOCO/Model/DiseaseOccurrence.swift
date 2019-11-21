/*
Copyright © 2019 arbovirosis. All rights reserved.

Abstract:
Contains the information about the point to be projected at the map
 
*/

import Foundation

struct DiseaseOccurrence: Codable {

    let id: CLong
    let diseaseName: String
    let confirmationStatus: Bool
    let initialSymptoms: String
    let created: String
    let latitude: Double
    let longitude: Double
//    var initialSymptomsDate: Date? {
//        let dateFormatter =  DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        return dateFormatter.date(from: initialSymptoms)
//    }
//    var createdDate: Date? {
//        let dateFormatter =  DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        return dateFormatter.date(from: created)
//    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case diseaseName = "diseaseName"
        case confirmationStatus = "confirmationStatus"
        case initialSymptoms = "initialSymptoms"
        case created = "created"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    init(diseaseName: String, initialSymptoms: String, confirmationStatus: Bool,
         created: String, latitude: Double, longitude: Double) {
        // Para efeito de POST, o parâmetro id precisa ser 0
        self.id = 0
        self.diseaseName = diseaseName
        self.confirmationStatus = confirmationStatus
        self.initialSymptoms = initialSymptoms
        self.created = created
        self.latitude = latitude
        self.longitude = longitude
    }

}
