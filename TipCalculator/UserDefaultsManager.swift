//
//  UserDefaultsManager.swift
//  TipCalculator
//
//  Created by anegrete on 9/30/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

struct Constants {
    static let DefaultTip       = "default_tip_percentage"
    static let LastUsedDate     = "last_used_date"
    static let LastBillAmount   = "last_bill_amount"
    static let LastTip          = "last_tip"
}

class UserDefaultsManager: NSObject {
    
    private class func defaults() -> UserDefaults {
        return UserDefaults.standard
    }

    class func register() {
        UserDefaults.standard.register(defaults:[Constants.DefaultTip : 15,
                                                 Constants.LastUsedDate : NSDate(),
                                                 Constants.LastBillAmount : "",
                                                 Constants.LastTip : ""])
    }
    
    // MARK: - Default Tip
    class func setDefaultTip(value: Float) {
        defaults().set(value, forKey: Constants.DefaultTip)
        defaults().synchronize()
    }
    
    class func defaultTip() -> Float {
        return defaults().float(forKey: Constants.DefaultTip)
    }
    
    // MARK: - Last Used Date
    
    class func setLastUsedDate(value: NSDate) {
        defaults().set(value, forKey: Constants.LastUsedDate)
        defaults().synchronize()
    }
    
    class func lastUsedDate() -> NSDate {
        return defaults().value(forKey: Constants.LastUsedDate) as! NSDate
    }
    
    // MARK: - Last Bill Amount
    
    class func setLastBillAmount(value: String) {
        defaults().set(value, forKey: Constants.LastBillAmount)
        defaults().synchronize()
    }
    
    class func lastBillAmount() -> String {
        return defaults().string(forKey: Constants.LastBillAmount)!
    }
    
    // MARK: - Last Tip
    class func setLastTip(value: Float) {
        defaults().set(value, forKey: Constants.LastTip)
        defaults().synchronize()
    }
    
    class func lastTip() -> Float {
        return defaults().float(forKey: Constants.LastTip)
    }

    // MARK: - Reset

    // Reset last bill amount
    class func resetLast() {
        UserDefaultsManager.setLastBillAmount(value: "")
    }
}
