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

// TODO: controls colors
class RosterCalendarControlView: UIView {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Properties
    
    var shiftRota: ShiftRota {
        didSet {
            schemeName = shiftRota.name
            schemeAttributedText = shiftRota.attributedFormat() { (workShift) -> (textColor: UIColor, backgroundColor: UIColor) in
                let dayColors = RosterCalendarColors.color(with: workShift)
                
                return (dayColors.textColor, dayColors.backgroundColor)
            }
        }
    }
    
    lazy var schemeNameTextField: UITextField = {
        let textField = UITextField()
        let pickerView = UIPickerView()
        let toolbar = self.createPickerToolbar(action: #selector(hideSchemeTextPicker))
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
        
        return textField
    }()
    
    lazy var schemeTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        textField.addTarget(self, action: #selector(schemeTextChanged), for: .editingChanged)
        
        return textField
    }()
    
    lazy var firstWorkDayTextField:UITextField = {
        let textField = UITextField()
        textField.delegate = self
        let toolbar = self.createPickerToolbar(action: #selector(hideDatePicker))
        let datePickerView = UIDatePicker()

        datePickerView.datePickerMode = .date
        textField.inputView = datePickerView
        textField.inputAccessoryView = toolbar
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        self.addSubview(view)
        
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 10        
        
        view.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        return view
    }()
    
    fileprivate var schemeAttributedText: NSAttributedString {
        set {
            let selectedTextRange = schemeTextField.selectedTextRange
            schemeTextField.attributedText = newValue
            schemeTextField.selectedTextRange = selectedTextRange
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
    
    
    // MARK: - Private API
    
    private func createUI() {
        stackView.addArrangedSubview(schemeNameTextField)
        stackView.addArrangedSubview(schemeTextField)
        stackView.addArrangedSubview(firstWorkDayTextField)
        
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
        delegate?.controlView(self, didChangeFirstWorkDay: firstWorkDayDate)
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
}

extension RosterCalendarControlView {
    
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
            subview.isHidden = firstResponder != subview
            subview.alpha = firstResponder != subview ? 0.0 : 1.0;
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
}


extension RosterCalendarControlView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc fileprivate func schemeTextChanged() {
        shiftRota = ShiftRota(name: "", format: schemeAttributedText.string)
        delegate?.controlView(self, didChangeShiftRota: shiftRota)
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
        return shiftRotaNameOrDefault(Data.allShiftRotas[row].name)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shiftRota = Data.allShiftRotas[row]
        
        delegate?.controlView(self, didChangeShiftRota: shiftRota)
    }
}

protocol RosterCalendarControlViewDelegate {
    func controlView(_ controlView: RosterCalendarControlView, didChangeShiftRota shiftRota: ShiftRota)
    func controlView(_ controlView: RosterCalendarControlView, didChangeFirstWorkDay firstWorkDay: Date?)
}
