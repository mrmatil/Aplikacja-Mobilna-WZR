//
//  LecturersPartTimeViewController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 05/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class LecturersPartTimeViewController: UIViewController {

    //variables
    var lecturersArray = [String]()
    var datesArray = [String]()
    var chosenLecturer:String = ""
    var tempLecturer:String = ""
    var date:String=""
    var tempDate:String=""
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var classroom = [String]()
    var group = [String]()
    let userDefaults=UserDefaults()
    var lecturersPickerView: UIPickerView!
    var datesPickerView: UIPickerView!
    
    
    //IBOutlets:
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var lecturerTextField: UITextField!
    @IBOutlet weak var lecturersTableView: UITableView!
    
    
    //IBActions
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        chosenLecturer=tempLecturer
        getCurrentLecturersData{}
        updateUI()
        endEditing()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLecturersArray()
        getDatesArray()
        getCurrentLecturersData {
            self.enableTableView()
        }
        // Do any additional setup after loading the view.
    }
    
    
    //getting data functions:
    
    func getLecturersArray(){
        lecturersArray = userDefaults.array(forKey: "lecturersList") as! [String]
        chosenLecturer=lecturersArray[0]
        lecturerTextField.text=chosenLecturer
        enableLecturersPickerView()
    }
    
    func getDatesArray(){
        datesArray = userDefaults.array(forKey: "datesList") as! [String]
        date = datesArray[0]
        dateTextField.text=date
        enableDatesPickerView()
    }
    
    func getCurrentLecturersData(completionHandler:@escaping ()->Void){
        startHour = [String]()
        endHour = [String]()
        className = [String]()
        classroom = [String]()
        group = [String]()
        GetDataFromDatabasePT.init(lecturer: chosenLecturer, date: date) { (results) in
            print(results)
            if results.count>0{
                for x in 0...results.count-1{
                    self.startHour.append(results[x].startHour!)
                    self.endHour.append(results[x].endHour!)
                    self.className.append(results[x].className!)
                    self.group.append(results[x].group!)
                    self.classroom.append(results[x].classroom!)
                }
            }
            completionHandler()
        }.getLecturersData()
    }
    
    func updateUI(){
        dateTextField.text=date
        lecturerTextField.text=chosenLecturer
        lecturersTableView.reloadData()
    }

}


extension LecturersPartTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{
    

    //Lecturers Picker View:
    
    func enableLecturersPickerView(){
        lecturersPickerView = UIPickerView()
        lecturersPickerView.delegate=self
        lecturersPickerView.dataSource=self
        lecturerTextField.inputView=lecturersPickerView
    }
    
    //Date PickerView:
    func enableDatesPickerView(){
        datesPickerView = UIPickerView()
        datesPickerView.delegate=self
        datesPickerView.dataSource=self
        dateTextField.inputView=datesPickerView
        enableToolbar()
    }
    
    func enableToolbar(){
        let toolbar = UIToolbar()
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okDatesButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Powrót" , style: .plain, target: self, action: #selector(cancelDatesButtonPressed))
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func okDatesButtonPressed(){
        if tempDate != ""{
            date = tempDate
            getCurrentLecturersData{}
            updateUI()
        }
        endEditing()
    }
    
    @objc func cancelDatesButtonPressed(){
        endEditing()
    }
    
    //Both Picker Views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == lecturersPickerView{
            return lecturersArray.count
        }else{
            return datesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == lecturersPickerView{
            return lecturersArray[row]
        }else{
            return datesArray[row]+" ("+CurrentDate.nameOfTheDayPT(date: datesArray[row])+")"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == lecturersPickerView{
            tempLecturer = lecturersArray[row]
        }else{
            tempDate=datesArray[row]
        }
    }
    
    //Table View:
    func enableTableView(){
        lecturersTableView.delegate=self
        lecturersTableView.dataSource=self
        lecturersTableView.estimatedRowHeight = 80.0
        lecturersTableView.rowHeight = UITableView.automaticDimension
        lecturersTableView.register(UINib(nibName: "LecturersCustomCell", bundle: nil), forCellReuseIdentifier: "customLecturersCell")
        lecturersTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startHour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customLecturersCell", for: indexPath) as! LecturersCustomCell
        
        cell.startHour.text = startHour[indexPath.row]
        cell.endHour.text = endHour[indexPath.row]
        cell.group.text = group[indexPath.row]
        cell.className.text = className[indexPath.row]
        cell.classroom.text = classroom[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func endEditing(){
        view.endEditing(true)
    }
}
