//
//  ColorCalendarUITests.swift
//  ColorCalendarUITests
//
//  Created by Mariano Heredia on 3/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest

class ColorCalendarUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        app.launch()    
        app.tables.staticTexts["ColorCalendarViewExample"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColorCalendarExists()
    {
        XCTAssert(app.otherElements["ColorCalendarView"].exists)
    }
    
    func testPreviousMonthExists() {
        XCTAssert(app.buttons["Previous month"].exists)
    }
    
    func testNextMonthExists() {
        XCTAssert(app.buttons["Next month"].exists)
    }
    
    func testCurrentMonthExists() {
        XCTAssert(app.buttons["Current month"].exists)
    }
    
    func testOutputLabelExists() {
        XCTAssert(app.staticTexts["Output"].exists)
    }
    
    func testCalendarDayViewAccesibility() {        
        XCTAssert(app.cells["Today"].exists)
    }
    
    func testOutputLabelChangingOnDayViewTap() {
        XCTAssert(!app.staticTexts["Today"].exists)
        app.cells["Today"].tap()
        XCTAssert(app.staticTexts["Today"].exists)
    }
    
    func testBelowViewIncreasingHeight() {
        //        app.staticTexts["Output"]
        let outputView = app.staticTexts["Output"]
        let oldOutputViewHeight = outputView.frame.height
        app.buttons["Add random text"].tap()
        XCTAssertLessThan(oldOutputViewHeight, outputView.frame.height)
        
    }
    
}
