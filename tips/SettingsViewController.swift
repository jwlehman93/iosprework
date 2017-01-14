//
//  SettingsViewController.swift
//  tips
//
//  Created by Erin Walsh on 12/8/15.
//  Copyright © 2015 Jeremy Lehman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    //initalize variables
    @IBOutlet weak var colorSchemeControl: UISegmentedControl!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    //intialize NSUserDefaults for settings
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //update tip segment control if exists to correct setting
        if(defaults.object(forKey: "tipPercent") != nil){
            tipSlider.value = Float(defaults.integer(forKey: "tipPercent"))
            tipPercentLabel.text = "\(defaults.integer(forKey: "tipPercent"))%"
        }
        //update color scheme segment control if exists to correct setting
        if(defaults.object(forKey: "colorIndex") != nil) {
            colorSchemeControl.selectedSegmentIndex = defaults.integer(forKey: "colorIndex")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        //save default tip and color scheme settings
        super.viewWillDisappear(animated)
        defaults.set(Int(tipSlider.value),forKey: "tipPercent")
        defaults.set(colorSchemeControl.selectedSegmentIndex, forKey:"colorIndex")
        defaults.synchronize()
        
    }
    @IBAction func onValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        tipPercentLabel.text = "\(currentValue)"
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
