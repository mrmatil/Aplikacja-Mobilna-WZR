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
    var arrayOfAllDates:[String] = [] //array of all dates
    //values from realm:
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var lecturer = [String]()
    var classroom = [String]()
    //-------------------------
    var datePick:String? //current date that user picked
    var tempDatePick:String? // temporary value that user picked in picker view but not confirmed
    var groupPickerView:UIPickerView! //groups pickerView
    var datePickerView:UIPickerView! //dates pickerView

    
    
    //IBOutlets:
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var groupsTextField: UITextField!
    @IBOutlet weak var lastRefreshLabel: UILabel!
    @IBOutlet weak var subjectsTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    //IBActions:
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        userDefaults.removeObject(forKey: "isNeededToReloadPartTime")
        print("pop to refresh")
        self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsData()
        getDatesData()
        getCurrentDataForClasses {
            self.enableTableView()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refreshCurrentDate()
    }
    
    //
    func refreshData(){
        getCurrentDataForClasses {}
        subjectsTableView.reloadData()
    }
    
    func refreshLastDate(){
        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshPartTime") else {
            lastRefreshLabel.text = "Nigdy nie odświeżono"
            return
        }
        lastRefreshLabel.text = "Dane z dnia: \(temp)"
    }
    
    func refreshCurrentDate(){
        let temp = CurrentDate.getDayOfTheWeek() + " " +  CurrentDate.getCurrentDateWithoutHoursAndMinutes()
        currentDateLabel.text = "Obecnie jest " + temp
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
    
    func getDatesData(){
        let temp = userDefaults.array(forKey: "datesList") as! [String]
        arrayOfAllDates=temp
        dateTextField.text=arrayOfAllDates[0]
        enableDatePickerView()
    }
    
    
    func getCurrentDataForClasses(completionHandler:@escaping ()->Void){
        startHour = [String]()
        endHour = [String]()
        className = [String]()
        lecturer = [String]()
        classroom = [String]()
        GetDataFromDatabasePT(group: pick ?? "", date: datePick ?? "") { (results) in
            print(results)
            if results.count>0{
                for x in 0...results.count-1{
                    self.startHour.append(results[x].startHour!)
                    self.endHour.append(results[x].endHour!)
                    self.className.append(results[x].className!)
                    self.lecturer.append(results[x].lecturer!)
                    self.classroom.append(results[x].classroom!)
                }
            }
            completionHandler()
        }.getData()
        refreshLastDate()
    }
    

}

extension TimeTablePartTimeController: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    
    //Table View:
    @objc func enableTableView(){
        subjectsTableView.delegate=self
        subjectsTableView.dataSource=self
        subjectsTableView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellReuseIdentifier: "customSubjectsCell")
        subjectsTableView.estimatedRowHeight = 80.0
        subjectsTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startHour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSubjectsCell", for: indexPath) as! TimeTableCell
        
        cell.startTime.text = startHour[indexPath.row]
        cell.endTime.text = endHour[indexPath.row]
        cell.lecturerName.text = lecturer[indexPath.row]
        cell.className.text = className[indexPath.row]
        cell.locationName.text = classroom[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
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
            refreshData()
            hide()
        }else{hide()}
    }
    
    @objc func cancelGroupsButtonPressed(){
        hide()
    }
    
    //datePickerView:
    func enableDatePickerView(){
        datePickerView = UIPickerView()
        datePickerView.delegate=self
        datePickerView.dataSource=self
        dateTextField.inputView=datePickerView
        enableDatesToolbar()
    }
    
    func enableDatesToolbar(){
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
        datePick=tempDatePick
        dateTextField.text=datePick
        refreshData()
        hide()
    }
    
    @objc func cancelDatesButtonPressed(){
        hide()
    }

    
    //both PickerViewFunctions:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupPickerView{
            return arrayOfAllGroupsString.count
        }
        else if pickerView == datePickerView{
            return arrayOfAllDates.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == groupPickerView{
            return arrayOfAllGroupsString[row]
        }else if pickerView == datePickerView{
            return arrayOfAllDates[row]
        } else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == groupPickerView{
            return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue]) // do poprawienia kolor z RGB
        }else{ //for dates pickerView:
            return NSAttributedString(string: arrayOfAllDates[row]+" ("+CurrentDate.nameOfTheDayPT(date: arrayOfAllDates[row])+")", attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == groupPickerView{
            tempPick=arrayOfAllGroupsString[row]
        } else{ //for dates pickerView:
            tempDatePick=arrayOfAllDates[row]
        }
    }
    
    func hide(){
        self.view.endEditing(true)
    }
    
    
}
