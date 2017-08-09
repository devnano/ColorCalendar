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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        app.launch()
        app.tables.staticTexts["ColorCalendarViewExample"].tap()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
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
//        app.staticTexts["Output"]
        XCTAssert(!app.staticTexts["Today"].exists)
        
        app.cells["Today"].tap()
        
        XCTAssert(app.staticTexts["Today"].exists)
    }
    
}
