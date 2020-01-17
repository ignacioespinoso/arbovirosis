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

class BreedingSitesTest: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreatingBreedingSiteSuccessfully() {
        let expectation = XCTestExpectation(description: "Expect an error, as both error and info are nil on Mock DAO")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let breedingSiteService = BreedingSitesServices()

        let breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 2.33, longitude: 4.45)

        breedingSiteService.breedingSitesDAO = BreedingSiteErrorMockDAO()

        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

         wait(for: [expectation], timeout: 5.0)
    }

    func testCreateBreedingSiteLongitudeBoundaries() {
        let errorExpectation = XCTestExpectation(description: "Expect an error, as longitude value exceeded boundaries")

        let breedingSiteService = BreedingSitesServices()
        breedingSiteService.breedingSitesDAO = BreedingSiteMockDAO()

        // Test superior limit exceeding
        var breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: 180.1)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        // Test inferior limit exceeding
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: -180.1)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        let successExpectation = XCTestExpectation(description: "Expect no error, as longitude value is within boundaries")
        // Test superior limit correct
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: 179.9)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test exact superior limit
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: 180.0)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test inferior limit correct
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: -179.9)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test exact inferior superior limit
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: -180.0)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test with 0
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }
         wait(for: [errorExpectation, successExpectation], timeout: 5.0)
    }

    func testCreateBreedingSiteLatitudeBoundaries() {
        let errorExpectation = XCTestExpectation(description: "Expect an error, as latitude value exceeded boundaries")

        let breedingSiteService = BreedingSitesServices()
        breedingSiteService.breedingSitesDAO = BreedingSiteMockDAO()

        // Test superior limit exceeding
        var breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 90.1, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        // Test inferior limit exceeding
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: -90.1, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        let successExpectation = XCTestExpectation(description: "Expect no error, as latitude value is within boundaries")

        // Test superior limit correct
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 89.9, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test exact superior limit
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 90, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test inferior limit correct
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: -89.9, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test exact inferior superior limit
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: -90, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test with 0
        breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

         wait(for: [errorExpectation, successExpectation], timeout: 5.0)
    }

    func testTitleBoundaries() {
        let errorExpectation = XCTestExpectation(description: "Expect an error, as title violated boundaries")
        let successExpectation = XCTestExpectation(description: "Expect success, as title length was within boundaries")

        let breedingSiteService = BreedingSitesServices()
        breedingSiteService.breedingSitesDAO = BreedingSiteMockDAO()

        // Test superior limit exceeding (61)
        var titleString = "Teste teste teste teste teste teste teste teste teste teste t"
        var breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        // Test superior limit (60)
        titleString = "Teste teste teste teste teste teste teste teste teste teste "
        breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test superior limit (59)
        titleString = "Teste teste teste teste teste teste teste teste teste teste "
        breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test inferior limit exceeding (2)
        titleString = "Te"
        breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNotNil(error)
            errorExpectation.fulfill()
        }

        // Test superior limit (3)
        titleString = "Tes"
        breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        // Test superior limit (4)
        titleString = "Test"
        breedingSite = BreedingSite(title: titleString, description: nil, type: "Publico", latitude: 0.00, longitude: 0.00)
        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            successExpectation.fulfill()
        }

        wait(for: [errorExpectation, successExpectation], timeout: 5.0)
    }

    func testPassingDataToDAO() {
         let expectation = XCTestExpectation(description: "The data shall be passed properly to the DAO")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let breedingSiteService = BreedingSitesServices()

        let breedingSite = BreedingSite(title: "Site de Teste", description: nil, type: "Publico", latitude: 2.33, longitude: 4.45)

        breedingSiteService.breedingSitesDAO = BreedingSitePassingDataMockDAO(expectation)

        breedingSiteService.createSite(breedingSite: breedingSite, image: nil) { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }

         wait(for: [expectation], timeout: 5.0)
    }
}
