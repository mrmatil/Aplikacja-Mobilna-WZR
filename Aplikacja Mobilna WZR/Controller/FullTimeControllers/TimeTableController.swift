//
//  TimeTableController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift

class TimeTableController: UIViewController {

    //variables:    
    let userDefaults = UserDefaults.standard
    var Pick:String? //current group pick
    var tempPick:String? // temporary group pick
    var arrayOfAllGroupsString:[String] = [] //array of all groups
    var week:Int = 1 // 1 -> pierwszy tydzień, 2 -> drugi tydzień
    var day: String =  "poniedziałek"
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var lecturer = [String]()
    var classroom = [String]()

    //po załadowaniu się widoku:
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsData()
        GetDataFromDatabase(group: userDefaults.string(forKey: "currentGroup")!, week: week, day: day) { (results) in
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
            self.SubjectsTableView.delegate=self
            self.SubjectsTableView.dataSource=self
            self.SubjectsTableView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellReuseIdentifier: "customSubjectsCell")
        }.getData()
        // Do any additional setup after loading the view.
    }
    
    //po pojawieniu się widoku
    override func viewDidAppear(_ animated: Bool) {
        whatWeekLabel.text = "Obecnie mamy \(CurrentDate.getDayOfTheWeek()) \(CurrentDate.getCurrentTypeOfWeek()) tygodnia"
//        getCurrentData()
//        SubjectsTableView.reloadData()
    }
    
    //IBOutlets:
    @IBOutlet weak var SubjectsTableView: UITableView!
    @IBOutlet weak var whatWeekLabel: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    
    //IBActions:
    @IBAction func weekPickerChanged(_ sender: UISegmentedControl) {
        week = sender.selectedSegmentIndex+1
        print("week: \(week)")
        getCurrentData()
        SubjectsTableView.reloadData()
    }
    @IBAction func dayPickerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            day = "poniedziałek"
        case 1:
            day = "wtorek"
        case 2:
            day = "środa"
        case 3:
            day = "czwartek"
        case 4:
            day = "piątek"
        default:
            day = "poniedziałek"
        }
        getCurrentData()
        print("day: \(day)")
        SubjectsTableView.reloadData()
    }
    
    
    func getCurrentData(){
        startHour = [String]()
        endHour = [String]()
        className = [String]()
        lecturer = [String]()
        classroom = [String]()
        GetDataFromDatabase(group: userDefaults.string(forKey: "currentGroup")!, week: week, day: day) { (results) in
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
            }.getData()
    }
    
    func getGroupsData(){
        guard let tempListOfGroups = userDefaults.array(forKey: "groupsList") else {return}
        arrayOfAllGroupsString = tempListOfGroups as! [String]
        Pick = userDefaults.string(forKey: "currentGroup")
        groupTextField.text = Pick
        enablePickerView()
    }
}




extension TimeTableController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{

    //TableView:
    
//    func changeCellHeight(){
//        //        messagesTableView.rowHeight = UITableView.automaticDimension
//        //        messagesTableView.estimatedRowHeight = 120.0
//        SubjectsTableView.rowHeight = UITableView.automaticDimension
//        SubjectsTableView.estimatedRowHeight = 60.0
//    }
    
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
    
    
    //PickerView:
    
    func enablePickerView(){
        let groupPickerView = UIPickerView()
        groupPickerView.delegate=self
        groupPickerView.dataSource=self
        groupTextField.inputView=groupPickerView
        enableToolbar()
    }
    
    func enableToolbar() {
        let toolbar = UIToolbar()
        
        let okButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(okButtonPickerPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Powrót" , style: .plain, target: self, action: #selector(cancelButtonPressed))
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        groupTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func okButtonPickerPressed(){
        Pick = tempPick
        if let pickDefault = Pick{
            userDefaults.set(pickDefault ,forKey: "currentGroup")
            getCurrentData()
            groupTextField.text = pickDefault
            SubjectsTableView.reloadData()
            hide()
        }else{hide()}
    }
    
    @objc func cancelButtonPressed(){
        hide()
    }
    
    func hide(){
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfAllGroupsString.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue]) // do poprawienia kolor z RGB
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempPick = arrayOfAllGroupsString[row]
    }
    
}
