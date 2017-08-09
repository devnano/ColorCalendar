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
    @IBOutlet fileprivate weak var colorCalendarView: ColorCalendarView!
    @IBOutlet fileprivate weak var outputLabel: UILabel!
    private var delegate: ColorCalendarViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = createColorCalendarViewDelegate()
        colorCalendarView.delegate = delegate
    }
}

extension ColorCalendarViewController {
    func createColorCalendarViewDelegate() -> ColorCalendarViewDelegate {
        return TestColorCalendarViewDelegate(self)
    }
}

class TestColorCalendarViewDelegate: ColorCalendarViewDelegate {
    unowned let colorCalendarViewController: ColorCalendarViewController
    
    required init(_ colorCalendarViewController: ColorCalendarViewController) {
        self.colorCalendarViewController = colorCalendarViewController
    }
    func colorCalendarDidSwitchForwardOneMonth(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidSwitchBackwardOneMonth(_ calendar: ColorCalendarView) {
    }
    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int) {
    }
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isCurrentMonth: Bool) {
        let text = date.full(withLocale: Locale.current)
        colorCalendarViewController.outputLabel.text = text
        colorCalendarViewController.outputLabel.accessibilityLabel = text
    }
}




