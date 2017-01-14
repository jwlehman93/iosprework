//
//  ViewController.swift
//  tips
//
//  Created by Jeremy Lehman on 12/7/15.
//  Copyright © 2015 Jeremy Lehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //initialize all view components
    @IBOutlet weak var calcView: UIView!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var sumBar: UIView!
    @IBOutlet weak var tipStatic: UILabel!
    @IBOutlet weak var tipPercentageStatic: UILabel!
    @IBOutlet weak var totalStatic: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    //initialize NSUser defaults for settings
    let defaults = UserDefaults.standard
    var currencySymbol = (Locale.current as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as! String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set intial tip and total labels to $0
        tipLabel.text = "\(currencySymbol)0.00"
        totalLabel.text = "\(currencySymbol)0.00"
        /*check if time from previous close exists
          if so, checks if it has been greater than 
          10 mins and if not sets bill amount to
          saved amount if exists and updates tip and
          total label
        */if(defaults.object(forKey: "previousMin") != nil) {
            let prevMin = defaults.integer(forKey: "previousMin")
            let currentDate = DateComponents()
            let curMin = currentDate.minute
            billField.placeholder = currencySymbol
            if(abs(prevMin - curMin! )<10){
                if(defaults.object(forKey: "billAmount") != nil) {billField.text = defaults.string(forKey: "billAmount")
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* check if default tip Percentage has been set
            if set, changes selected segment in main view
            and updates tip and total labels
        */if(defaults.object(forKey: "tipPercent") != nil){
        
            let percentage = defaults.float(forKey: "tipPercent")/100
            tipSlider.value = defaults.float(forKey: "tipPercent")
            tipPercentLabel.text = "\(defaults.integer(forKey: "tipPercent"))%"
            let billAmount = NSString(string:billField.text!).doubleValue
            let tip = billAmount * Double(percentage)
            let total = billAmount + tip
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let tipStr = formatter.string(from: NSNumber(value: tip))
            let totalStr = formatter.string(from: NSNumber(value: total))
            
            tipLabel.text = tipStr!
            totalLabel.text = totalStr!

        }
        /*check if index for color scheme exists
           then implement color scheme
        */
        if(defaults.object(forKey: "colorIndex") != nil) {
            let color = defaults.integer(forKey: "colorIndex")
            setColors(color)
        }
        //set positions of views
        if(billField.text?.characters.count == 0){
            calcView.frame = CGRect(x: 0,y: self.view.frame.maxY, width: calcView.frame.maxX, height: calcView.frame.maxY)
            billField.center = self.view.center
        }
        else {
            calcView.frame = CGRect(x: 0,y: 200,width: self.view.frame.maxX,height: 400)
            billField.center = CGPoint(x: self.view.center.x,y: 120)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        //saves bill amount and time of close
        super.viewWillDisappear(animated)
        defaults.set(billField.text, forKey: "billAmount")
        let date = DateComponents()
        defaults.set(date.minute, forKey: "previousMin")
        defaults.synchronize()
    }

    func setColors(_ colorIndex : Int) {
        if(colorIndex == 1) {
            view.backgroundColor = UIColor.darkGray
            calcView.backgroundColor = UIColor.black
            // set all text colors to green
            billField.textColor = UIColor.green
            tipLabel.textColor = UIColor.green
            totalLabel.textColor = UIColor.green
            tipStatic.textColor = UIColor.green
            totalStatic.textColor = UIColor.green
            billField.backgroundColor = UIColor.darkGray
            tipPercentageStatic.textColor = UIColor.green
            tipPercentLabel.textColor = UIColor.green
            tipSlider.thumbTintColor = UIColor.darkGray
            tipSlider.tintColor = UIColor.green
           
            sumBar.backgroundColor = UIColor.green
        }
        else if(colorIndex == 0) {
            view.backgroundColor = UIColor.white
            calcView.backgroundColor = UIColor.lightGray
            billField.textColor = UIColor.black
            tipLabel.textColor = UIColor.black
            tipStatic.textColor = UIColor.black
            totalLabel.textColor = UIColor.black
            totalStatic.textColor = UIColor.black
            billField.backgroundColor = UIColor.clear
            tipPercentageStatic.textColor = UIColor.black
            tipPercentLabel.textColor = UIColor.black
            tipSlider.thumbTintColor =
                nil
            tipSlider.tintColor = self.view.tintColor
            sumBar.backgroundColor = UIColor.black
        }
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(_ sender: AnyObject) {
        /*updates text field and tip and total labels as things are typed into it. Also formats values for current locale
        */
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let percentage = Double(tipSlider.value/100)
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * percentage
        let total = billAmount + tip
        
        let tipStr = formatter.string(from: NSNumber(value: tip))
        let totalStr = formatter.string(from: NSNumber(value: total))
        
        tipLabel.text = tipStr!
        totalLabel.text = totalStr!
        if(billField.text?.characters.count == 1) {
            UIView.animate(withDuration: 0.4,animations: {
                self.calcView.frame = CGRect(x: 0,y: 200,width: self.view.frame.maxX,height: 400)
                self.billField.center = CGPoint(x: self.view.center.x,y: 120)

            })
        }
        else if(billField.text?.characters.count == 0) {
            UIView.animate(withDuration: 0.4, animations:{
                self.calcView.frame = CGRect(x: 0,y: self.view.frame.maxY, width: self.calcView.frame.maxX, height: self.calcView.frame.maxY)
                self.billField.center = self.view.center
            })
        }
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        //push keyboard down when screen is click?d
        view.endEditing(true)
        currencySymbol = (Locale.current as NSLocale).object(forKey: NSLocale.Key.currencySymbol) as! String
        billField.placeholder = currencySymbol
    }
    /*triggered when percent slider is changed.
      updates all relevant labels
    */
    @IBAction func tipValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        tipPercentLabel.text = "\(currentValue)%"
        let percentage = Double(currentValue)/100
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * percentage
        let total = billAmount + tip
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let tipStr = formatter.string(from: NSNumber(value: tip))
        let totalStr = formatter.string(from: NSNumber(value: total))
        tipLabel.text = tipStr!
        totalLabel.text = totalStr!
    }

 
}

