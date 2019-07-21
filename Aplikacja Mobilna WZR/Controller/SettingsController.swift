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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let temp = defaults.array(forKey: "groupsList") else {return}
        tempArray = temp as! [String]
        enablePickerView()
        // Do any additional setup after loading the view.
    }
    
    //IBOutlets:
    @IBOutlet weak var groupsPickerView: UIPickerView!
    
    
    //variables:
    var tempArray:[String] = []
    var pick:String?

    
    //IBActions:
    @IBAction func okButtonPressed(_ sender: UIButton) {
        // zapisywanie dodać
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
        return tempArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: tempArray[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pick=tempArray[row]
        print(pick!)
        defaults.set(pick!, forKey: "currentGroup")
    }
    
}

