//
//  DateTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class DateTests: XCTestCase {
    
    var date: Date!
    var locale: Locale!
    var calendar: Calendar!
    
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        super.setUp()
        createDate()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMonthName() {
        XCTAssert(date.monthName(withLocale: locale) == "August")
    }
    
    func testMonthNameEs() {
        XCTAssert(date.monthName(withLocale: Locale(identifier: "ES_es")) == "Agosto")
    }
    
    func testYear() {
        XCTAssert(date.year(withCalendar: calendar) == 2016)
    }
    
    func testDayOrdinal() {
        XCTAssert(date.dayOrdinal(withCalendar: calendar) == "8th")
    }
    
    func testFull() {
        createDate(day: 10)
        XCTAssertEqual(date.full(withLocale: locale), "Wednesday, August 10, 2016")
    }
    
    func testFullSpanish() {
        let components = DateComponents(calendar: calendar, day: 2)
        date = calendar.date(byAdding: components, to: Date())!
        
        
        XCTAssertEqual(date.full(withLocale: Locale(identifier: "ES_es")), "Pasado Mañana")
    }
    
    private func createDate(year: Int = 2016, month: Int = 8, day: Int = 8) {
        
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        date = calendar.date(from: dateComponents)!
    }
}
