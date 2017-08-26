//
//  RosterCalendarControlView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit
import Roster
import ColorCalendar

// TODO: controls colors
class RosterCalendarControlView: UIView {
    
    private var schemeTextControl: ControlItemContainerView?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Properties
    
    var allShiftRotas: [ShiftRota] = [ShiftRota]()
    
    var shiftRota: ShiftRota {
        didSet {
            schemeName = shiftRota.name
            schemeAttributedText = shiftRota.attributedFormat() { (workShift) -> (textColor: UIColor, backgroundColor: UIColor) in
                let dayColors = RosterCalendarColors.color(with: workShift)
                
                return (dayColors.textColor, dayColors.backgroundColor)
            }
        }
    }
    
    lazy var pickerView: UIPickerView = {
        return UIPickerView()
    }()
    
    lazy var datePicker: UIDatePicker = {
        return UIDatePicker()
    }()
    
    lazy var schemeNameTextField: UITextField = {
        let textField = self.createTextField()
        
        let toolbar = self.createPickerToolbar(action: #selector(hideSchemeTextPicker))
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        textField.inputView = self.pickerView
        textField.inputAccessoryView = toolbar
        textField.tag = 0
        
        
        return textField
    }()
    
    lazy var schemeTextField: UITextField = {
        let textField = self.createTextField()
        
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(schemeTextChanged), for: .editingChanged)
        textField.tag = 1
//        textField.placeholder = "esta"
        
        
        return textField
    }()
    
    lazy var firstWorkDayTextField: UITextField = {
        let textField = self.createTextField()
        
        let toolbar = self.createPickerToolbar(action: #selector(hideDatePicker))
        

        self.datePicker.datePickerMode = .date
        textField.inputView = self.datePicker
        textField.inputAccessoryView = toolbar
        textField.tag = 2
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        self.addSubview(view)
        
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = CalendarFonts.calendarFonts.adjustSizeByScreenSize(size: 5)
        
        view.snp.makeConstraints({ (make) in
            make.center.left.equalToSuperview()
        })
        
        return view
    }()
    
    fileprivate var schemeAttributedText: NSAttributedString {
        set {
            let selectedTextRange = schemeTextField.selectedTextRange
            let attributedString = NSMutableAttributedString(attributedString: newValue)
            attributedString.addAttributes([NSFontAttributeName: schemeTextField.font!], range: NSRange(location: 0, length: attributedString.length))
            
            schemeTextField.attributedText = attributedString
            schemeTextField.selectedTextRange = selectedTextRange
            
            // XXX: this is a workaround to avoid having the text cut or not centered. It happens when there is only a single character on the attributed string or it has just a single attribute for background.
            schemeTextField.setNeedsLayout()
            schemeTextField.layoutIfNeeded()
            
            let maxFrame = CGSize(width: self.frame.size.width, height: schemeTextField.frame.size.height)
            let resultingFrame = attributedString.boundingRect(with: maxFrame, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
            let currentFrame = schemeTextField.frame
            if abs(resultingFrame.size.width - currentFrame.size.width) > 5 {
                // Manuall adjust the frame if has not grown / shrinked enough after chaning the string.
                let center = schemeTextField.center
                schemeTextField.frame = CGRect(origin: currentFrame.origin, size: CGSize(width: resultingFrame.width, height: currentFrame.height))
                schemeTextField.center = center
            }
            // END of XXXX
        }
        get {
            return schemeTextField.attributedText ?? NSAttributedString(string: "")
        }
    }
    
    private var schemeName: String {
        set {
            let name = shiftRotaNameOrDefault(newValue)
            schemeNameTextField.text = name
        }
        get {
            return schemeNameTextField.text ?? ""
        }
    }
    
    var firstWorkDayDate: Date? {
        didSet {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            self.datePicker.date = firstWorkDayDate!
            
            firstWorkDayTextField.text = dateFormatter.string(from: firstWorkDayDate!)
        }
    }
    
    var delegate: RosterCalendarControlViewDelegate?
    
    // MARK: - UIView methods
    
    public override init(frame: CGRect) {
        shiftRota = Data.currentShiftRota
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        shiftRota = Data.currentShiftRota
        super.init(coder: aDecoder)
        createUI()
    }
    
    public func showHelp() {
        schemeTextControl?.showHelp()
    }
    
    // MARK: - Private API
    
    private func createUI() {
        
        stackView.addArrangedSubview(ControlItemContainerView(controlView: schemeNameTextField, label: R.string.localizable.controlViewSchemePickerLabel(), helpText: schemeNameHelp()))
        schemeTextControl = ControlItemContainerView(controlView: schemeTextField, label: R.string.localizable.controlViewSchemeTextLabel(), helpText: schemeSequenceHelp())
        stackView.addArrangedSubview(schemeTextControl!)
        stackView.addArrangedSubview(ControlItemContainerView(controlView: firstWorkDayTextField, label: R.string.localizable.controlViewFirstWorkDayLabel(), helpText: firstWorkDayHelp()))
        
        addKeyboardObservers()
        addApplicationObservers()
    }
    
    fileprivate func shiftRotaNameOrDefault(_ shiftRotaName:String) -> String {
        return shiftRotaName != "" ? shiftRotaName : R.string.localizable.controlViewButtonShiftRotaTitle()
    }
    
    @objc private func hideDatePicker() {
        firstWorkDayTextField.resignFirstResponder()
    }
    
    @objc private func hideSchemeTextPicker() {
        schemeNameTextField.resignFirstResponder()
    }

    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        firstWorkDayDate = sender.date
        delegate?.controlView(self, didChangeFirstWorkDay: sender.date)
    }
    
    private func createPickerToolbar(action:Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: action)
        
        
        toolbar.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        
        toolbar.setItems([doneButton], animated: false)
        
        return toolbar
    }
    
    fileprivate func change(shiftRota: ShiftRota) {
        self.shiftRota = shiftRota
        delegate?.controlView(self, didChangeShiftRota: shiftRota)
        Data.currentShiftRota = shiftRota
    }
    
    
    fileprivate func createTextField() -> UITextField {
        let textField = UITextField()
        
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.textColor = CalendarColors.calendarColors.defaultTextColor
        textField.font = CalendarFonts.calendarFonts.defaultFont(size: 25)
        
        return textField
    }
}

extension RosterCalendarControlView {
    
    func updateAllShiftRotas() {
        let defaultShiftRotas = Data.allShiftRotas
        let currentShiftRota = Data.currentShiftRota
        
        if defaultShiftRotas.contains(currentShiftRota) {
            allShiftRotas = defaultShiftRotas
            return
        }
        
        var shiftRotas = [ShiftRota]()
        shiftRotas.append(currentShiftRota)
        shiftRotas.append(contentsOf: defaultShiftRotas)
        
        
        allShiftRotas = shiftRotas
    }

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
    
    func keyboardDidShow(notification: Notification) {
        var firstResponder: UIView!
        
        if schemeTextField.isFirstResponder {
            firstResponder = schemeTextField
        } else if firstWorkDayTextField.isFirstResponder {
            firstResponder = firstWorkDayTextField
        } else if schemeNameTextField.isFirstResponder {
            firstResponder = schemeNameTextField
        } else {
            return
        }

        animate(keyboardNotification: notification) { (subview) in
            let isHidden = !subview.subviews.contains(firstResponder)
            subview.isHidden = isHidden
            subview.alpha = isHidden ? 0.0 : 1.0;
        }
    }
    
    func keyboardDidHide(notification: Notification) {
        animate(keyboardNotification: notification) { (subview) in
            subview.isHidden = false
            subview.alpha = 1.0;
        }
    }
    
    func animate(keyboardNotification notification: Notification, subviewChange: @escaping (UIView) -> Void) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey]  as! NSNumber

        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: { () -> Void in
            for subview in self.stackView.arrangedSubviews {
                subviewChange(subview)
            }
            self.layoutIfNeeded()
        }) { (finished) -> Void  in

        }
    }
    
    func schemeNameHelp() -> NSAttributedString {
        let text = R.string.localizable.controlViewSchemePickerHelp()
        let attributedString = mutableAttributedHelpString(fromText: text)
        let ranges = ["(X:Y) X =", "Y ="].map({substr in text.range(of: substr)!})
        
        
        for substringRange in ranges {
            attributedString.swiftAddAttributes([NSFontAttributeName: CalendarFonts.calendarFonts.boldFont(size: 15)], range: substringRange)
        }
        
        return attributedString
    }
    
    func schemeSequenceHelp() -> NSAttributedString {
        var allShifts = WorkShift.allWorkShifts
        allShifts.append(.free)
        let workShiftsString = allShifts.map({shift in "\(shift.localizedRawValue()): \(shift.localizedName())"}).joined(separator: "\n")
        let text = R.string.localizable.controlViewSchemeTextHelp(workShiftsString)
        let attributedString = mutableAttributedHelpString(fromText: text)
        
        for shift in allShifts {
            let range = text.range(of: "\(shift.localizedRawValue())")!
            let colors = RosterCalendarColors.color(with: shift)
            
            let substr = text.substring(from: text.index(after: range.upperBound))
            let nlRange = substr.range(of: "\n")!
            let boldText = substr.substring(to: nlRange.lowerBound)
            let boldTextRange = text.range(of: boldText)!
            
            attributedString.swiftAddAttributes([NSForegroundColorAttributeName: colors.textColor, NSBackgroundColorAttributeName: colors.backgroundColor, NSFontAttributeName: CalendarFonts.calendarFonts.defaultFont(size: 20)], range: range)
            attributedString.swiftAddAttributes([NSFontAttributeName: CalendarFonts.calendarFonts.boldFont(size: 15)], range: boldTextRange)
        }
        
        return attributedString
    }
    
    func firstWorkDayHelp() -> NSAttributedString {
        return mutableAttributedHelpString(fromText: R.string.localizable.controlViewFirstWorkDayHelp())
    }
    
    func mutableAttributedHelpString(fromText text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text, attributes: [NSFontAttributeName : CalendarFonts.calendarFonts.defaultFont(size: 15), NSForegroundColorAttributeName: CalendarColors.calendarColors.weekdaySymbolColor.textColor])
        
        return attributedString
    }
}

extension NSMutableAttributedString {
    func swiftAddAttributes(_ attributes: [String:Any], range substringRange: Range<String.Index>) {
        let start = string.distance(from: string.startIndex, to: substringRange.lowerBound)
        let length = string.distance(from: substringRange.lowerBound, to: substringRange.upperBound)
        let range = NSMakeRange(start, length)
        
        addAttributes(attributes, range: range)
    }
}


extension RosterCalendarControlView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc fileprivate func schemeTextChanged() {
        change(shiftRota: ShiftRota(name: "", format: schemeAttributedText.string, locale: .current))
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        Analytics.startEditingTextField(index: textField.tag)
        if textField != schemeNameTextField {
            return
        }
        updateAllShiftRotas()
        let selectedIndex = allShiftRotas.index(of: shiftRota) ?? 0
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
}

extension RosterCalendarControlView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Data.allShiftRotas.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shiftRotaNameOrDefault(allShiftRotas[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        change(shiftRota: allShiftRotas[row])
    }
}

protocol RosterCalendarControlViewDelegate {
    func controlView(_ controlView: RosterCalendarControlView, didChangeShiftRota shiftRota: ShiftRota)
    func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date)
}
