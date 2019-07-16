//
//  ViewController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //IBOutlets:
    @IBOutlet weak var groupsPickerView: UIPickerView!
    
    
    //variables:
    var tempArray:[String] = []
    var pick:String?

    
    //IBActions:
    @IBAction func okButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "WelcomeToTimetable", sender: self)
    }
    
    func answer(array: [String])->[String]{
        tempArray=array
        enablePickerView()
        return array
    }
}




extension WelcomeScreenController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
    }
    
}

