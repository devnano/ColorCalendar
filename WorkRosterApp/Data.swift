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
    
    private static let currentWorkSchemeKey = "currentWorkSchemeKey"
    
    // MARK: - Internal API
    
    static var currentWorkScheme:WorkScheme {
        get {
            if let workScheme = workScheme(forKey: currentWorkSchemeKey) {
                return workScheme
            }
            
            return allWorkSchemes.first!
        }
        set {
            set(newValue, forkey: currentWorkSchemeKey)
        }
    }
    
    static var allWorkSchemes:[WorkScheme] {
        return [WorkScheme(name:"default", format:"M,D,D,D,X,E,N")]        
    }
    
    // MARK: - Private Methods
    
    private static func workScheme(forKey key:String) -> WorkScheme? {
        return object(forKey: key) as! WorkScheme?
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
