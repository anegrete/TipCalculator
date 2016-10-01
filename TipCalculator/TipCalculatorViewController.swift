//
//  TipCalculatorViewController.swift
//  TipCalculator
//
//  Created by anegrete on 9/30/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class TipCalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var total2Label: UILabel!
    @IBOutlet weak var total3Label: UILabel!
    @IBOutlet weak var total4Label: UILabel!


    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotifications()
        self.billTextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tipSlider.value = UserDefaultsManager.defaultTip()
        self.updateTipPercentageLabel()
        self.updateValues()
        self.updateLastStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Notifications
    
    func addNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillResignActive),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)
        
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)
    }

    // When the application becomes active update with the last tip, bill and date
    @objc func applicationDidBecomeActive(notification: Notification) {
        self.updateLastStatus()
    }
    
    // When the application is going to background, save last tip, bill and date
    @objc func applicationWillResignActive(notification: Notification) {
        UserDefaultsManager.setLastTip(value: self.tipSlider.value)
        UserDefaultsManager.setLastUsedDate(value: NSDate())
        UserDefaultsManager.setLastBillAmount(value: self.billTextField.text!)
    }
    
    func updateLastStatus() {
        let lastUsedDate = UserDefaultsManager.lastUsedDate()
        let now = NSDate()

        // Check the time between last used date and current date
        let timeInterval = now.timeIntervalSince(lastUsedDate as Date)
        
        let lastBill = UserDefaultsManager.lastBillAmount()
        if (timeInterval < (60) && lastBill != "") {
            self.billTextField.text = UserDefaultsManager.lastBillAmount()
            self.tipSlider.value = UserDefaultsManager.lastTip()
            self.updateTipPercentageLabel()
            self.updateValues()
            self.showTipView(show: true)
        }
    }
    
    // MARK: - UI Actions

    // Called when the user tap the view
    @IBAction func onViewTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // Called when the bill amount changes
    @IBAction func onBillTextFieldEditingChanged(_ sender: UITextField) {
        self.updateValues()
        UserDefaultsManager.resetLast()
    }

    // Called when the tip percentage value changes in the segmented control
    @IBAction func onTipPercentageValueChanged(_ sender: UISegmentedControl) {
        let commonTipPercentages = [15, 18, 20]
        self.tipSlider.value = Float(commonTipPercentages[tipSegmentedControl.selectedSegmentIndex])
        self.updateValues()
        UserDefaultsManager.resetLast()
    }
    
    // Called when the tip percentage value changes in the slider
    @IBAction func onTipPercentageValueChangedSlider(_ sender: UISlider) {
        self.updateValues()
        UserDefaultsManager.resetLast()
    }
    
    // MARK: - Animations
    
    func showTipViewAnimated(show: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.showTipView(show: show)
        })
    }

    func showTipView(show: Bool) {
        var inputViewFrame = self.billTextField.frame
        inputViewFrame.size.height = show ? 120 : 280
        self.billTextField.frame = inputViewFrame

        self.totalView.alpha = show ? 1 : 0
        self.tipView.alpha = show ? 1 : 0
    }

    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let bill = billTextField.text!
        if (bill == "" && string == ".") {
            billTextField.text = "0"
        }
        else if (bill == "" && string != "") {
            self.showTipViewAnimated(show: true)
        }
        else if (string == "" && bill.characters.count == 1) {
            self.showTipViewAnimated(show: false)
        }
        let dotsCount = (bill.components(separatedBy: ".").count)

        // Don't allow more than 1 decimal point
        if dotsCount > 1 && string == "." {
            return false
        }

        return true
    }
    
    // MARK: - Util
    
    // Format text showing locale specific currency and currency thousands separator
    func formattedText(value: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = NSLocale.current
        return currencyFormatter.string(from: NSNumber.init(value: value))!
    }

    // Update UI
    func updateValues() {
        
        // Get the selected tip percentage
        let tipSliderValue = roundedTipSliderValue();
        
        // Get the bill amount input by the user
        let bill = Double(billTextField.text!) ?? 0
        
        // Calculate tip amount
        let tip = bill * Double(tipSliderValue) / 100
        
        // Calculate total
        let total = bill + tip
        
        // Update labels
        self.updateTipPercentageLabel()
        self.tipLabel.text = formattedText(value: tip)
        self.totalLabel.text = formattedText(value: total)
        self.total2Label.text = formattedText(value: total/2)
        self.total3Label.text = formattedText(value: total/3)
        self.total4Label.text = formattedText(value: total/4)
    }
    
    func updateTipPercentageLabel() {
        self.tipPercentageLabel.text = String(format: "%.0f%%", roundedTipSliderValue())
    }
    
    func roundedTipSliderValue() -> Float {
        return roundf(tipSlider.value)
    }
}
