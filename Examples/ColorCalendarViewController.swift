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
    @IBAction func onAddRandomTextTap(_ sender: Any) {
        outputLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla pretium imperdiet neque sed pretium. Etiam id elit porttitor, dapibus magna a, eleifend felis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis ornare sollicitudin lacus in pretium. Ut pellentesque orci ac elit mollis efficitur."
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
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isCurrentMonth: Bool, in window: UIWindow, from frame: CGRect) {
        let text = date.full(withLocale: Locale.current)
        colorCalendarViewController.outputLabel.text = text
        colorCalendarViewController.outputLabel.accessibilityLabel = text
    }
}




