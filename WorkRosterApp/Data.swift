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
    private static let currentFirstWorkDayKey = "currentFirstWorkDayKey"
    
    // MARK: - Internal API
    
    static var currentShiftRota:ShiftRota {
        get {
            let defaultWorkScheme = UserDefaults.standard.string(forKey: "defaultWorkScheme")
            
            if defaultWorkScheme != nil {
                set(currentShiftRota: ShiftRota(defaultWorkScheme!))
            }
            
            if let shiftRota = shiftRota(forKey: currentShiftRotaKey) {
                return shiftRota
            }
            
            return allShiftRotas.first!
        }
        set {
            set(currentShiftRota: newValue)
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
    
    static var currentFirstWorkDay: Date {
        get {
            return object(forKey: currentFirstWorkDayKey) as! Date? ?? Date()
        }
        set {
            set(newValue, forkey: currentFirstWorkDayKey)
        }
    }

    // MARK: - Private Methods
    
    private static func shiftRota(forKey key:String) -> ShiftRota? {
        return object(forKey: key) as! ShiftRota?
    }
    
    private static func object(forKey key:String) -> Any? {
        let object = UserDefaults.standard.object(forKey: key)
        
        guard let data = object else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Foundation.Data)
    }
    
    private static func set(_ value: Any, forkey key:String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private static func set(currentShiftRota: ShiftRota) {
        set(currentShiftRota, forkey: currentShiftRotaKey)
    }
}
