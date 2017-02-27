//
//  Data.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation
import Roster

struct Data {
    // MARK: - Constants
    
    private static let currentShiftRotaKey = "currentShiftRotaKey"
    
    // MARK: - Internal API
    
    static var currentShiftRota:ShiftRota {
        get {
            if let shiftRota = shiftRota(forKey: currentShiftRotaKey) {
                return shiftRota
            }
            
            return allShiftRotas.first!
        }
        set {
            set(newValue, forkey: currentShiftRotaKey)
        }
    }
    
    static let allShiftRotas:[ShiftRota] = {
        var system = ShiftSystem(workDays: 5, freeDays: 2)
        var shiftworkType: ShiftworkType = .fixed
        var shiftsPerDay: [WorkShift] = [.day, .morning, .night]
        var generator = ShiftRotaGenerator(shiftworkType: shiftworkType, shiftSystem: system, shiftsPerDay: shiftsPerDay)
        var allRotas = [ShiftRota]()
        
        allRotas.append(contentsOf: generator.generate())
        
        generator.shiftworkType = .rotating(1)
        
        allRotas.append(contentsOf: generator.generate())
        
        generator.shiftworkType = .rotating(2)
        generator.shiftSystem = generator.shiftSystem * 2
        
        allRotas.append(contentsOf: generator.generate())
        
        generator.shiftSystem = ShiftSystem(workDays: 6, freeDays: 2)
        
        allRotas.append(contentsOf: generator.generate())
        
        return allRotas
    }()
    
    // MARK: - Private Methods
    
    private static func shiftRota(forKey key:String) -> ShiftRota? {
        return object(forKey: key) as! ShiftRota?
    }
    
    private static func object(forKey key:String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private static func string(forKey key:String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    private static func set(_ value: Any?, forkey key:String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
