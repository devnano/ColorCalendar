//
//  ColorCalendarDayViewTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 4/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest

class ColorCalendarDayViewTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    func testColorCalendarExists()
//    {
//        app.tables.staticTexts["ColorCalendarDayViewExample"].tap()
//        XCTAssert(app.otherElements["1"].exists)
//    }
}
