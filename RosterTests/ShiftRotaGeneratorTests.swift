//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class ShiftRotaGeneratorTests: XCTestCase {
    
    var system: ShiftSystem!
    var generator: ShiftRotaGenerator!
    
    override func setUp() {
        super.setUp()
        system = ShiftSystem(workDays: 3, freeDays: 1)
    }
}
