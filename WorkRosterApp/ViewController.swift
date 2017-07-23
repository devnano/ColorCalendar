//
//  ViewController.swift
//  WorkRosterApp
//
//  Created by Mariano Heredia on 12/22/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import ColorCalendar
import SnapKit
import Roster

class ViewController: UIViewController {
    
    
    // TODO: use real control view height after hidding some of the arrenged views
    fileprivate static var minControlViewHeight: CGFloat = CalendarFonts.calendarFonts.adjustSizeByScreenSize(size: 70.0)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Properties
    
    lazy var colorCalendar: ColorCalendarView = {
        let calendarView = ColorCalendarView(frame:CGRect())
        let roster = Roster(shiftRota: self.shiftRota, firstWorkDay: self.firstWorkDay)!
        
        self.calendarHighlight.firstWeekdayDay = 2
        
        self.set(roster:roster)
        
        self.view.addSubview(calendarView)
        
        calendarView.calendar = self.calendarHighlight
        
        calendarView.delegate = self
        
        return calendarView
    }()
    
    lazy var colorCalendarImageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.isHidden = true
        
        return imageView
    }()
    
    lazy var controlView: RosterCalendarControlView = {
        let cView = RosterCalendarControlView(frame:CGRect())
        cView.delegate = self
        
        self.view.addSubview(cView)

        cView.firstWorkDayDate = self.firstWorkDay
        cView.shiftRota = self.shiftRota
        
        return cView
    }()
    
    var firstWorkDay:Date {
        get {
            return Data.currentFirstWorkDay
        }
        set {
            Data.currentFirstWorkDay = newValue
        }
    }
    
    lazy var calendarHighlight:CalendarHighlights = {
        
        let highlight = CalendarHighlights(Date())
        
        return highlight
    }()
    
    lazy var shiftRota = Data.currentShiftRota
    
    var colorCalendarHeightConstraint: Constraint?
    var controlBottomConstraint: Constraint!
    var controlHeightConstraint: Constraint?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        makeCalendarConstraints(with: self.view.frame.size)
        makeControlViewConstraints(with: self.view.frame.size)
        
        addApplicationObservers()
        addKeyboardObservers()
        
        self.view.backgroundColor = RosterCalendarColors.palette.workRosterAppBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controlView.showHelp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        makeCalendarConstraints(with: size)
        makeControlViewConstraints(with: size)
    }
    
    // MARK: - Private Methods
    
    typealias ConstraintMaker = (SnapKit.ConstraintMaker) -> Void
    
    private func makeTraitsDependantConstraints(with size: CGSize, compactMaker: @escaping ConstraintMaker, regularMaker: @escaping ConstraintMaker) -> ConstraintMaker {
        if isCompactWidth(size) {
            return compactMaker
        } else {
            return regularMaker
        }
    }
    
    fileprivate func isCompactWidth(_ size: CGSize) -> Bool {
         return size.width < size.height
    }
    private func makeCalendarConstraints(with size: CGSize) {
        make(calendarView: colorCalendarImageView, constraintsWith: size)
        make(calendarView: colorCalendar, constraintsWith: size)
    }
    
    private func make(calendarView: UIView, constraintsWith size: CGSize) {
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.centerX.equalToSuperview()
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.left.equalToSuperview()
        }
        
        calendarView.snp.remakeConstraints {(make) -> Void in
            let mediumPriority = 750
            
            // Required:
            makeTraitsDependantConstraints(with: size,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)

            make.width.equalTo(calendarView.snp.height)
            make.width.height.lessThanOrEqualToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            
            // Nice to have:
            make.left.equalToSuperview().offset(5).priority(mediumPriority)
            make.right.equalToSuperview().offset(-5).priority(mediumPriority)
            make.bottom.equalToSuperview().priority(mediumPriority)
        }
    }
    
    private func makeControlViewConstraints(with size: CGSize) {        
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalTo(colorCalendarImageView.snp.bottom)
            controlBottomConstraint = make.bottom.equalToSuperview().constraint
            make.left.equalToSuperview().offset(5)
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(colorCalendarImageView.snp.right)
            controlBottomConstraint = make.bottom.equalTo(colorCalendarImageView).constraint
        }
        
        controlView.snp.remakeConstraints {(make) -> Void in
            makeTraitsDependantConstraints(with: size,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    fileprivate func set(roster: Roster, reloadCalendar reload:Bool=false) {
        CalendarColors.calendarColors = RosterCalendarColors(roster: roster)
        CalendarFonts.calendarFonts = RosterCalendarFonts(roster: roster)
        if reload {
            colorCalendar.reloadCalendar()
        }
        
        updateColorCalendarImageView()
    }
    
    fileprivate func updateColorCalendarImageView() {
        DispatchQueue.main.async {
            self.colorCalendarImageView.image = self.colorCalendar.asImage
        }

    }
}

extension ViewController: RosterCalendarControlViewDelegate {
    internal func controlView(_ controlView: RosterCalendarControlView, didChangeShiftRota shiftRota: ShiftRota) {
        self.shiftRota = shiftRota
        guard let roster = Roster(shiftRota: shiftRota, firstWorkDay: firstWorkDay) else {
            Analytics.changeToInvalidShiftRota(format: shiftRota.format)
            return
        }
        
        Analytics.changeToValidShiftRota(format: shiftRota.format)
        
        
        set(roster:roster, reloadCalendar: true)
    }

    internal func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date) {
        self.firstWorkDay = firstWorkDay
        
        Analytics.changeFirstWorkDay(date: firstWorkDay)
        
        guard let roster = Roster(shiftRota: shiftRota, firstWorkDay: firstWorkDay) else {
            Analytics.changeToInvalidShiftRota(format: shiftRota.format)
            return
        }
        
        set(roster:roster, reloadCalendar: true)
    }
}

extension ViewController {
    
    func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func willResignActive(notification: NSNotification) {
        removeKeyboardObservers()
    }
    
    func didBecomeActive(notification: NSNotification) {
        addKeyboardObservers()
    }    
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func keyboardDidShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        var keyboardRect = keyboardFrame.cgRectValue
        keyboardRect = (colorCalendar.superview?.convert(keyboardRect, to: colorCalendar.window!))!
        
        
        var offset = colorCalendar.frame.maxY - keyboardRect.minY
        var newControlViewHeight: CGFloat?
        
        if isCompactWidth(self.view.frame.size) {
            newControlViewHeight = max(ViewController.minControlViewHeight, -offset)
            
            if offset < 0 {
                offset = newControlViewHeight! + offset
            } else {
                offset += newControlViewHeight!
            }
        }
        
        if newControlViewHeight != nil {
            controlBottomConstraint.deactivate()
            controlView.snp.makeConstraints { (make) in
                controlHeightConstraint = make.height.equalTo(newControlViewHeight!).constraint
            }
        }
        
        
        if offset > 0 {
            let newHeight = colorCalendar.frame.height - offset
            colorCalendarHeightConstraint?.deactivate()
                
            colorCalendarImageView.snp.makeConstraints { (make) in
                colorCalendarHeightConstraint = make.height.equalTo(newHeight).constraint
            }
        }
        
        animate(grow: false, withNotification: notification)
    }
    
    func keyboardDidHide(notification: NSNotification) {        
        colorCalendarHeightConstraint?.deactivate()
        controlHeightConstraint?.deactivate()
        controlBottomConstraint.activate()
        animate(grow: true, withNotification: notification)
        colorCalendarHeightConstraint = nil
    }
    
    func animate(grow: Bool, withNotification notification: NSNotification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]  as! UInt
        // TODO: check iPad issue when rotating and keyboard appears / dissapears   
        if !grow {
            colorCalendar.isHidden = true
            colorCalendarImageView.isHidden = false
        } else {
            // Note: this should be ideally on completion block of below animation dispatch. Comletion (with finished == true) It being executed too prematurely and here's a work-around this:
            let deadline = DispatchTime.now() + (duration * 1.5)
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.colorCalendar.isHidden = false
                self.colorCalendarImageView.isHidden = true
            })
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        /*{ (finished) -> Void  in
            if finished && grow {
                self.colorCalendar.isHidden = false
            }
        }*/
    }
}

extension ViewController: ColorCalendarViewDelegate {
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isCurrentMonth: Bool) {
        Analytics.tapInCalendarDay(date, isCurrentMonth: isCurrentMonth)
    }

    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int) {
        Analytics.tapInWeekdaySymbolAtIndex(index)
    }

    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView) {
        Analytics.tapOnMonthName()
    }

    func colorCalendarDidSwitchForwardOneMonth(_ calendar: ColorCalendarView) {
        updateColorCalendarImageView()
        Analytics.tapOnSwitchForwardOnMonth()
    }
    func colorCalendarDidSwitchBackwardOneMonth(_ calendar: ColorCalendarView) {
        updateColorCalendarImageView()
        Analytics.tapOnSwitchBackwardOnMonth()
    }
}

extension UIView {
    
    var asImage: UIImage{
        let wasHidden = self.isHidden
        self.isHidden = false
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.isHidden = wasHidden
        
        return UIImage(cgImage: (image?.cgImage)!)
    }
}
