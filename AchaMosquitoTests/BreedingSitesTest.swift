//
//  File.swift
//  AchaMosquitoTests
//
//  Created by Ignácio Espinoso Ribeiro on 14/01/20.
//  Copyright © 2020 arbovirosis. All rights reserved.
//

import Foundation
import XCTest

@testable import Acha_Mosquito_

class BreedingSiteMockDAO: BreedingSitesDAO {
    func createBreedingSite(jsonData: Data?, _ completion: @escaping (Error?, Int?) -> Void) {

        let error = URLError(URLError.Code.badURL)

        completion(error, nil)
    }
}

class BreedingSitePassingDataMockDAO: BreedingSitesDAO {
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

class BreedingSitesTest: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let expectation = XCTestExpectation(description: "Expect an error, as both error and info are nil on Mock DAO")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let breedingSiteService = BreedingSitesServices()

        let breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 2.33, longitude: 4.45)

        breedingSiteService.beedingSitesDAO = BreedingSiteMockDAO()

        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

         wait(for: [expectation], timeout: 5.0)
    }

    func testPassingDataToDAO() {
         let expectation = XCTestExpectation(description: "The data shall be passed properly to the DAO")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let breedingSiteService = BreedingSitesServices()

        let breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 2.33, longitude: 4.45)

        breedingSiteService.beedingSitesDAO = BreedingSitePassingDataMockDAO(expectation)

        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }

         wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
