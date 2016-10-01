//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by anegrete on 10/1/16.
//  Copyright © 2016 Alejandra Negrete. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        self.tipSlider.value = UserDefaultsManager.defaultTip()
        self.updateTipPercentageLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UI Updates

    @IBAction func onTipValueChanged(_ sender: UISlider) {
        UserDefaultsManager.setDefaultTip(value: tipSlider.value)
        self.updateTipPercentageLabel()
    }

    // MARK: - Util

    func updateTipPercentageLabel() {
        self.tipPercentageLabel.text = String(format: "%.0f%%", roundf(tipSlider.value))
    }
}
