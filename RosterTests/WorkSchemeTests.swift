//
//  WorkSchemeTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class WorkSchemeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let format = "D,N,X"
        let scheme = WorkScheme(name: "", format: format)
        
        XCTAssert(scheme.format == format)
    }
    
}
