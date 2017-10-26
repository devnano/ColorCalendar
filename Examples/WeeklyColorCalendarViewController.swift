//
//  WeeklyColorCalendarViewController.swift
//  Examples
//
//  Created by Mariano Heredia on 26/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar

class WeeklyColorCalendarViewController: ColorCalendarViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        colorCalendarView.calendar = WeeklyCalendarLayout(Date())
    }
    
}
