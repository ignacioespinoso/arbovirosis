//
//  BreedingSitesMocks.swift
//  AchaMosquitoTests
//
//  Created by Ignácio Espinoso Ribeiro on 15/01/20.
//  Copyright © 2020 arbovirosis. All rights reserved.
//

import Foundation
import XCTest
@testable import Acha_Mosquito_

class BreedingSiteErrorMockDAO: BreedingSitesDAO {
    func findAll(_ completion: @escaping (Error?, [BreedingSite]?) -> Void) {

    }

    func findById(breedingId: Int, _ completion: @escaping (Error?, BreedingSite?) -> Void) {

    }

    func getImageById(breedingId: Int, _ completion: @escaping (Error?, [UInt8]?) -> Void) {

    }

    func uploadImageById(breedingId: Int, image: UIImage, _ completion: @escaping (Error?) -> Void) {

    }

    func reportSite(breedingSiteId: Int, completion: @escaping (Error?, Int?) -> Void) {

    }

    func createBreedingSite(jsonData: Data?, _ completion: @escaping (Error?, Int?) -> Void) {

        let error = URLError(URLError.Code.badURL)

        completion(error, nil)
    }
}

class BreedingSiteMockDAO: BreedingSitesDAO {
    func findAll(_ completion: @escaping (Error?, [BreedingSite]?) -> Void) {

    }

    func findById(breedingId: Int, _ completion: @escaping (Error?, BreedingSite?) -> Void) {

    }

    func getImageById(breedingId: Int, _ completion: @escaping (Error?, [UInt8]?) -> Void) {

    }

    func uploadImageById(breedingId: Int, image: UIImage, _ completion: @escaping (Error?) -> Void) {

    }

    func reportSite(breedingSiteId: Int, completion: @escaping (Error?, Int?) -> Void) {

    }

    func createBreedingSite(jsonData: Data?, _ completion: @escaping (Error?, Int?) -> Void) {
        completion(nil, nil)
    }
}

class BreedingSitePassingDataMockDAO: BreedingSitesDAO {
    func findAll(_ completion: @escaping (Error?, [BreedingSite]?) -> Void) {

    }

    func findById(breedingId: Int, _ completion: @escaping (Error?, BreedingSite?) -> Void) {

    }

    func getImageById(breedingId: Int, _ completion: @escaping (Error?, [UInt8]?) -> Void) {

    }

    func uploadImageById(breedingId: Int, image: UIImage, _ completion: @escaping (Error?) -> Void) {

    }

    func reportSite(breedingSiteId: Int, completion: @escaping (Error?, Int?) -> Void) {

    }

    var expectation: XCTestExpectation

    init(_ expectation: XCTestExpectation) {
        self.expectation = expectation
    }

    func createBreedingSite(jsonData: Data?, _ completion: @escaping (Error?, Int?) -> Void) {

        // Test if JSON comes from Service
        XCTAssertNotNil(jsonData)

        guard let data = jsonData else {
            completion(nil, nil)
            return
        }

        let decoded = try? JSONDecoder().decode(BreedingSite.self, from: data)

        // Check if data is a valid Breeding Site
        XCTAssertNotNil(decoded)

        // Test information was properly encoded
        XCTAssertEqual(decoded?.title, "Site de Teste")
        XCTAssertNil(decoded?.description)
        XCTAssertEqual(decoded?.type, "Publico")
        XCTAssertEqual(decoded?.latitude, 2.33)
        XCTAssertEqual(decoded?.longitude, 4.45)
        completion(nil, nil)
    }
}
