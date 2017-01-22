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
    // MARK: - Properties
    
    lazy var colorCalendar: ColorCalendarView = {
        let calendarView = ColorCalendarView(frame:CGRect())
        let roster = Roster(workScheme: self.workScheme, firstWorkDay: self.firstWorkDay)!
        
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
        imageView.backgroundColor = UIColor.red
        
        return imageView
    }()
    
    lazy var controlView: RosterCalendarControlView = {
        let cView = RosterCalendarControlView(frame:CGRect())
        cView.delegate = self
        
        self.view.addSubview(cView)

        cView.firstWorkDayDate = self.firstWorkDay
        cView.workScheme = self.workScheme
        
        return cView
    }()
    
    lazy var firstWorkDay:Date = {
        let date = Date()
        
        return date
    }()
    
    lazy var calendarHighlight:CalendarHighlights = {
        
        let highlight = CalendarHighlights(self.firstWorkDay)
        
        return highlight
    }()
    
    lazy var workScheme = Data.currentWorkScheme
    
    var heightConstraint: Constraint?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        makeCalendarConstraints(with: self.view.frame.size)
        makeControlViewConstraints(with: self.view.frame.size)
        
        addKeyboardObservers()
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
        if size.width < size.height {
            return compactMaker
        } else {
            return regularMaker
        }
    }
    
    private func makeCalendarConstraints(with size: CGSize) {
        make(calendarView: colorCalendarImageView, constraintsWith: size)
        make(calendarView: colorCalendar, constraintsWith: size)
    }
    
    private func make(calendarView: UIView, constraintsWith size: CGSize) {
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.centerX.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.left.equalToSuperview()
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            //make.centerY.equalToSuperview()
        }
        
        calendarView.snp.remakeConstraints {(make) -> Void in
            let mediumPriority = 750
            
            // Required:
            makeTraitsDependantConstraints(with: size,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)

            make.width.equalTo(calendarView.snp.height)
            make.width.height.lessThanOrEqualToSuperview()
            
            // Nice to have:
            make.left.right.equalToSuperview().priority(mediumPriority)
            make.bottom.equalToSuperview().priority(mediumPriority)
        }
    }
    
    private func makeControlViewConstraints(with size: CGSize) {
        func makeCalendarHorizontalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalTo(colorCalendar.snp.bottom)
            make.bottom.left.equalToSuperview()
        }
        
        func makeCalendarVerticalCompactConstraints(_ make:SnapKit.ConstraintMaker) {
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(colorCalendarImageView.snp.right)
            make.bottom.equalTo(colorCalendarImageView)
        }
        
        controlView.snp.remakeConstraints {(make) -> Void in
            makeTraitsDependantConstraints(with: size,
                                           compactMaker: makeCalendarHorizontalCompactConstraints,
                                           regularMaker: makeCalendarVerticalCompactConstraints)(make)
            make.right.equalToSuperview()
        }
    }
    
    fileprivate func set(roster: Roster, reloadCalendar reload:Bool=false) {
        CalendarColors.calendarColors = RosterCalendarColors(roster:roster)
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
    internal func controlView(_ controlView: RosterCalendarControlView, didChangeWorkScheme workScheme: WorkScheme) {
        self.workScheme = workScheme
        guard let roster = Roster(workScheme: workScheme, firstWorkDay: firstWorkDay) else {
            // TODO: errors
            return
        }
        
        set(roster:roster, reloadCalendar: true)
    }

    internal func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date?) {
        guard let firstWorkDay = firstWorkDay else {
            // TODO: error messages
            return
        }        
        
        guard let roster = Roster(workScheme: workScheme, firstWorkDay: firstWorkDay) else {
            // TODO: error messages
            return
        }
        
        set(roster:roster, reloadCalendar: true)
    }
}

extension ViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        var keyboardRect = keyboardFrame.cgRectValue
        keyboardRect = (colorCalendar.superview?.convert(keyboardRect, to: colorCalendar.window!))!
        let offset = colorCalendar.frame.maxY - keyboardRect.minY
        if offset > 0 {
            let newHeight = colorCalendar.frame.height - offset
            heightConstraint?.deactivate()
                
            colorCalendarImageView.snp.makeConstraints { (make) in
                heightConstraint = make.height.equalTo(newHeight).constraint
            }
            
            animate(grow: false, withNotification: notification)
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        guard let constraint = heightConstraint else {
            return
        }
        constraint.deactivate()
        animate(grow: true, withNotification: notification)
        heightConstraint = nil
    }
    
    func animate(grow: Bool, withNotification notification: NSNotification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]  as! NSNumber
        if !grow {
            colorCalendar.isHidden = true
        }
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (finished) -> Void  in
            if finished && grow {
                self.colorCalendar.isHidden = false
            }
        }
    }
}

extension ViewController: ColorCalendarViewDelegate {
    func colorCalendarDidSwitchForwardOneMonth(_ calendar: ColorCalendarView) {
        updateColorCalendarImageView()
    }
    func colorCalendarDidSwitchBackwardOneMonth(_ calendar: ColorCalendarView) {
        updateColorCalendarImageView()
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
