//
//  ColorCalendarViewController.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import ColorCalendar


class ColorCalendarViewController: UIViewController {
    @IBOutlet weak var colorCalendarView: ColorCalendarView!
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCalendarView.delegate = createColorCalendarViewDelegate()
    }
}

extension ColorCalendarViewController {
    func createColorCalendarViewDelegate() -> ColorCalendarViewDelegate {
        return TestColorCalendarViewDelegate()
    }
}

class TestColorCalendarViewDelegate: ColorCalendarViewDelegate {
    func colorCalendarDidSwitchForwardOneMonth(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidSwitchBackwardOneMonth(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isCurrentMonth: Bool) {
    }
}




