//
//  ShiftRotaGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

typealias RotationSpeed = Int

enum RotatingDirection {
    case clockwise(RotationSpeed)
    case counterclockwise(RotationSpeed)
}

extension RotatingDirection {
    var rotationSpeed: RotationSpeed {
        switch self {
        case let .clockwise(speed):
            return speed
        case let .counterclockwise(speed):
            return speed
        }
    }
}

enum ShiftworkType {
    case fixed
    case rotating(RotatingDirection)
}

extension ShiftworkType {
    var isRotating: Bool {
        switch self {
        case .rotating(_):
            return true
        default:
            return false
        }
    }
    
    var rotatingDirection: RotatingDirection? {
        switch self {
        case let .rotating(direction):
                return direction
        default:
                return nil
        }
    }
}

struct ShiftRotaGenerator {
    var shiftworkType: ShiftworkType
    var shiftSystem: ShiftSystem
    var shiftsPerDay: [WorkShift]
    
    func generate() -> [ShiftRota] {
        var array = [ShiftRota]()
        
        
        for shift in shiftsPerDay {
            var currentShift = shift
            var shiftSequence = [WorkShift]()
            
            for _ in 1...shiftSystem.workDays {
                shiftSequence.append(currentShift)                
                if shiftworkType.isRotating {
                    currentShift = shiftsPerDay.ciruclarNextElement(currentShift)!
                }
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
