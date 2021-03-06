//
//  TimeTableController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift
import BetterSegmentedControl

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


    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupsData()
        getCurrentDataForClasses {
            self.enableTableView()
        }
        addLeftRight()
        enablePickerView()
        enableSegmentControl()
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        reloadView()
    }
    
    //IBOutlets:
    @IBOutlet weak var SubjectsTableView: UITableView!
    @IBOutlet weak var whatWeekLabel: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var lastRefreshDayLabel: UILabel!
    @IBOutlet weak var weekPicker: BetterSegmentedControl!
    @IBOutlet weak var dayPicker: BetterSegmentedControl!
    
    //IBActions:
    
    @IBAction func weekPickerChanged(_ sender: BetterSegmentedControl) {
        week = Int(sender.index+1)
        print("week: \(week)")
        getCurrentDataForClasses {}
        SubjectsTableView.reloadData()
    }
    
    @IBAction func dayPickerChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
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
        getCurrentDataForClasses{}
        print("day: \(day)")
        SubjectsTableView.reloadData()
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        userDefaults.removeObject(forKey: "isNeededToReloadFullTime")
        print("pop to refresh")
        self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
    }
    
    //Functions:
    
    //getting data for chosen day and week with possible completion handler for enabling table view (for viewDidLoad)
    func getCurrentDataForClasses(completionHandler:@escaping ()->Void){
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
            completionHandler()
        }.getData()
    }
    
    //enabling segment controls
    func enableSegmentControl(){
        weekPicker = segmentControlUtils.getColours(array: ["Tydzień I","Tydzień II"], segmentControl: weekPicker)
        dayPicker = segmentControlUtils.getColours(array: ["Pon.","Wt.","Śr.","Czw.","Pt."], segmentControl: dayPicker)
        print(dayPicker.debugDescription)
    }
    
    
    //getting group list from user defaults
    func getGroupsData(){
        guard let tempListOfGroups = userDefaults.array(forKey: "groupsList") else {return}
        arrayOfAllGroupsString = tempListOfGroups as! [String]
        Pick = userDefaults.string(forKey: "currentGroup")
        groupTextField.text = Pick
        enablePickerView()
    }
    
    //refreshes label with last refresh date
    func refreshLastDate(){
        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshFullTime") else {
            lastRefreshDayLabel.text = "Nigdy nie odświeżono"
            return
        }
        lastRefreshDayLabel.text = "Dane z dnia: \(temp)"
    }
    
    
    //reloads everything <- handy with viewDidLoad/viewDidAppear
    func reloadView(){
        whatWeekLabel.text = "Obecnie mamy \(CurrentDate.getDayOfTheWeek()) \(CurrentDate.getCurrentTypeOfWeek()). tygodnia"
        refreshLastDate()
    }
    
    
    //addingGestures:
    func addLeftRight(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(actionAfterGesture) )
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(actionAfterGesture) )
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func actionAfterGesture(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
                
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                let swipedRight = GesturesUtil.gesturesForFullTImeTablesDecreasing(data: GesturesClass(week: week, day: day, weekForPicker: Int(weekPicker!.index), dayForPicker: Int(dayPicker!.index)))
                week = swipedRight.week
                day = swipedRight.day
                weekPicker.setIndex(swipedRight.weekForPicker)
                dayPicker.setIndex(swipedRight.dayForPicker)
                getCurrentDataForClasses {}
                SubjectsTableView.reloadData()
                
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                let swipedLeft = GesturesUtil.gesturesForFullTimeTimeTablesAdding(data: GesturesClass(week: week, day: day, weekForPicker: Int(weekPicker!.index), dayForPicker: Int(dayPicker!.index)))
                week = swipedLeft.week
                day = swipedLeft.day
                weekPicker.setIndex(swipedLeft.weekForPicker)
                dayPicker.setIndex(swipedLeft.dayForPicker)
                getCurrentDataForClasses {}
                SubjectsTableView.reloadData()
            default:
                break
            }
        }
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
    
    @objc func enableTableView(){
        SubjectsTableView.delegate=self
        SubjectsTableView.dataSource=self
        SubjectsTableView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellReuseIdentifier: "customSubjectsCell")
        SubjectsTableView.estimatedRowHeight = 80.0
        SubjectsTableView.rowHeight = UITableView.automaticDimension
        SubjectsTableView.separatorStyle = .none
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
        okButton.tintColor = UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Powrót" , style: .plain, target: self, action: #selector(cancelButtonPressed))
        cancelButton.tintColor = UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, okButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        groupTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func okButtonPickerPressed(){
        Pick = tempPick
        if let pickDefault = Pick{
            userDefaults.set(pickDefault ,forKey: "currentGroup")
            getCurrentDataForClasses{}
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
        return NSAttributedString(string: arrayOfAllGroupsString[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tempPick = arrayOfAllGroupsString[row]
    }
    
}

