//
//  DiseaseOccurrenceTest.swift
//  Acha MosquitoTests
//
//  Created by Ignácio Espinoso Ribeiro on 13/01/20.
//  Copyright © 2020 arbovirosis. All rights reserved.
//

import XCTest
@testable import Acha_Mosquito_

class DiseaseOccurrenceTest: XCTestCase {
    private var dso: DiseaseOccurrence!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        dso = DiseaseOccurrence(diseaseName: "test_name", confirmationStatus: false, initialSymptoms: "None", latitude: 0.0, longitude: 0.0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        XCTAssertEqual(dso.diseaseName, "test_name")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
