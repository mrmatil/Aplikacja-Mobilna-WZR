//
//  TimeTablePartTimeController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 02/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class TimeTablePartTimeController: UIViewController {

    //variables:
    let userDefaults = UserDefaults()
    var pick:String? //current group pick
    var tempPick:String? // temporary group pick
    var arrayOfAllGroupsString:[String] = [] //array of all groups
    var groupPickerView:UIPickerView! //groups pickerView

    
    
    //IBOutlets:
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var groupsTextField: UITextField!
    @IBOutlet weak var lastRefreshLabel: UILabel!
    
    //IBActions:
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsData()
        // Do any additional setup after loading the view.
    }
    
    
    //functions for getting data
    
    //getting from user defaults array of all groups and favorite group
    func getGroupsData(){
        let temp = userDefaults.array(forKey: "partTimeGroupsList") as! [String]
        let temp2 = userDefaults.string(forKey: "currentGroupPartTime")
        arrayOfAllGroupsString = temp
        pick = temp2
        groupsTextField.text=pick
        enableGroupsPickerView()
    }
    

}

extension TimeTablePartTimeController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    //groups Picker View:
    
    func enableGroupsPickerView(){
        groupPickerView = UIPickerView()  //groups pickerViev
        groupPickerView.delegate = self
        groupPickerView.dataSource = self
        groupsTextField.inputView = groupPickerView
        enableToolbar()
    }
    
    func enableToolbar(){
        let toolbar = UIToolbar()
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okGroupsButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Powrót" , style: .plain, target: self, action: #selector(cancelGroupsButtonPressed))
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        groupsTextField.inputAccessoryView = toolbar
    }
    
    @objc func okGroupsButtonPressed(){
        pick=tempPick
        if let pickDefault = pick{
            userDefaults.set(pickDefault ,forKey: "currentGroupPartTime")
            groupsTextField.text=pick
            hide()
        }else{hide()}
    }
    
    @objc func cancelGroupsButtonPressed(){
        hide()
    }
    
    //both PickerViewFunctions:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupPickerView{
            return arrayOfAllGroupsString.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == groupPickerView{
            return arrayOfAllGroupsString[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == groupPickerView{
            return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue]) // do poprawienia kolor z RGB
        }else{
            return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue]) // temporary
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempPick=arrayOfAllGroupsString[row]
    }
    
    func hide(){
        self.view.endEditing(true)
    }
    
    
}