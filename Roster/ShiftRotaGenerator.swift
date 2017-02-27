//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

struct ShiftRotaGenerator {
    var shiftworkType: ShiftworkType
    var shiftSystem: ShiftSystem
    var shiftsPerDay: [WorkShift]
    
    func generate() -> [ShiftRota] {
        var array = [ShiftRota]()
        
        
        for shift in shiftsPerDay {
            var currentShift = shift
            var shiftSequence = [WorkShift]()
            var currentShiftCount = 0
            
            for _ in 1...shiftSystem.workDays {
                
                if let speed = shiftworkType.rotatingSpeed {
                    if abs(speed) == currentShiftCount {
                        if speed < 0 {
                            currentShift = shiftsPerDay.ciruclarPreviousElement(currentShift)!
                        } else {
                            currentShift = shiftsPerDay.ciruclarNextElement(currentShift)!
                        }
                        currentShiftCount = 0
                    }
                }
                
                shiftSequence.append(currentShift)
                currentShiftCount += 1
            }
            
            for _ in 1...shiftSystem.freeDays {
                shiftSequence.append(.free)
            }
            
            // TODO: create names
            let rota = ShiftRota(shiftSequence)
            array.append(rota)
        }
        
        return array
    }
}
