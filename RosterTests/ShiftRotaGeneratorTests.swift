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
    var shiftworkType: ShiftworkType!
    var generator: ShiftRotaGenerator!
    var shiftsPerDay: [WorkShift]!
    
    override func setUp() {
        super.setUp()
        system = ShiftSystem(workDays: 3, freeDays: 1)
        shiftworkType = .rotating(1)
        shiftsPerDay = WorkShift.threeShiftsPerDay
        createGenerator()
    }
    
    func createGenerator() {
        generator = ShiftRotaGenerator(shiftworkType: shiftworkType, shiftSystem: system, shiftsPerDay: shiftsPerDay!)
    }
    
    func testGenerateClockwise1DayRotating3by1System3ShiftsPerDay() {
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 1)
            XCTAssert(rota.shiftSystem!.workDays == 3)
            XCTAssert(rota.shiftworkType! == .rotating(1))
        }
    }
    
    func testGenerateCounterclockwise1DayRotating3by1System3ShiftsPerDay() {
        shiftworkType = .rotating(-1)
        createGenerator()
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 1)
            XCTAssert(rota.shiftSystem!.workDays == 3)
            XCTAssert(rota.shiftworkType! == .rotating(-1))
        }
    }
    
    func testGenerateClockwiseFixed5by2System2ShiftsPerDay() {
        system = ShiftSystem(workDays: 5, freeDays: 2)
        shiftworkType = .fixed
        shiftsPerDay = [.day, .night]
        createGenerator()
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 2)
            XCTAssert(rota.shiftSystem!.workDays == 5)
            XCTAssert(rota.shiftworkType! == .fixed)
        }
    }
    
    func testGenerateClockwiseFixed7by7System2ShiftsPerDay() {
        system = ShiftSystem(workDays: 7, freeDays: 7)
        shiftworkType = .fixed
        shiftsPerDay = [.day, .night]
        createGenerator()
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 7)
            XCTAssert(rota.shiftSystem!.workDays == 7)
            XCTAssert(rota.shiftworkType! == .fixed)
        }
    }    
    
    func testGenerateFixed3by1System3ShiftsPerDay() {
        shiftworkType = .fixed
        createGenerator()
        let rotas = generator.generate()
        
        XCTAssert(rotas.count > 0)
        
        for rota in rotas {
            XCTAssert(rota.shiftSystem!.freeDays == 1)
            XCTAssert(rota.shiftSystem!.workDays == 3)
            XCTAssert(rota.shiftworkType! == .fixed)
        }
    }
}
