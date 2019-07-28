//
//  ViewController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    //zmienna dla userdefaults:
    let defaults = UserDefaults.standard
    
    var currentPick:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tempListOfGroups = defaults.array(forKey: "groupsList") else {return}
        arrayOfAllGroupsString = tempListOfGroups as! [String]
        enablePickerView()
        // Do any additional setup after loading the view.
    }
    
    //IBOutlets:
    @IBOutlet weak var groupsPickerView: UIPickerView!
    
    
    //variables:
    var arrayOfAllGroupsString:[String] = []
    var pick:String?
    
    
    //IBActions:
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        if let x = currentPick{
            defaults.set(x, forKey: "currentGroup")
            print("Changed fav group to: \(x)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}




extension SettingsController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func enablePickerView(){
        groupsPickerView.dataSource=self
        groupsPickerView.delegate=self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfAllGroupsString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pick=arrayOfAllGroupsString[row]
        //        print(pick!)
        currentPick=pick
        
        //        defaults.set(pick!, forKey: "currentGroup") // sending current pick to userDefaults
    }
    
}


