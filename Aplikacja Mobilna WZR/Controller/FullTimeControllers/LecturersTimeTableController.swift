//
//  LecturersTimeTableController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 28/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class LecturersTimeTableController: UIViewController {

    //variables:
    var chosenLecturer:String = ""
    var chosenLecturerEmail:String = ""
    var chosenLecturerInfo:String = ""
    var chosenLecturerWebsite:String = ""
    var week:Int = 1 // 1 -> pierwszy tydzień, 2 -> drugi tydzień
    var day: String =  "poniedziałek"
    let userDefaults = UserDefaults()
    
    //Realm Timetable variables:
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var classroom = [String]()
    var group = [String]()
    //------------------------
    
    //Realm Lecturers variables:
    var lecturersNames = [String]()
    var emails = [String]()
    var info = [String]()
    var websites = [String]()
    //-------------------------
    
    
    //IBOutlets:
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var lecturersTableView: UITableView!
    @IBOutlet weak var weekPicker: UISegmentedControl!
    @IBOutlet weak var dayPicker: UISegmentedControl!
    @IBOutlet weak var lastRefreshLabel: UILabel!
    
    
    //UIActions:
    @IBAction func weekPickerChanged(_ sender: UISegmentedControl) {
        week = sender.selectedSegmentIndex+1
        print("week: \(week)")
        getCurrentLecturersData{}
        lecturersTableView.reloadData()
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
        print("day: \(day)")
        getCurrentLecturersData{}
        lecturersTableView.reloadData()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        hideKeyboard()
        getCurrentLecturersData{}
        lecturersTableView.reloadData()
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FTLecturersDetails", sender: self)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        userDefaults.removeObject(forKey: "isNeededToReloadFullTime")
        print("pop to refresh")
        self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLecturersListAndInfo()
        if lecturersNames.count > 0{
            enableLecturersPickerView()
            getCurrentLecturersData {
                self.enableTableView()
            }
        }
        addLeftRight()
        refreshLastDate()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FTLecturersDetails"{
            let vc = segue.destination as! LecturersDetailsController
            vc.detailsArray.append(chosenLecturer)
            vc.detailsArray.append(chosenLecturerEmail)
            vc.detailsArray.append(chosenLecturerInfo)
            vc.website = chosenLecturerWebsite
        }
    }
    
    func getLecturersListAndInfo(){
        let temp = GetDataFromDatabaseLecturers.getData()
        if temp.count>0{
            for x in 0...temp.count-1{
                lecturersNames.append(temp[x].name!)
                emails.append(temp[x].email!)
                info.append(temp[x].info!)
                websites.append(temp[x].website!)
            }
        }
    }
    
    func getCurrentLecturersData(completionHandler:@escaping ()->Void){
        startHour = [String]()
        endHour = [String]()
        className = [String]()
        classroom = [String]()
        group = [String]()
        GetDataFromDatabase(lecturer: chosenLecturer, week: week, day: day) { results in
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
        }.getDataLecturers()
    }
    
    //refreshes label with last refresh date
    func refreshLastDate(){
        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshFullTime") else {
            lastRefreshLabel.text = "Nigdy nie odświeżono"
            return
        }
        lastRefreshLabel.text = "Dane z dnia: \(temp)"
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
                let swipedRight = GesturesUtil.gesturesForFullTImeTablesDecreasing(data: GesturesClass(week: week, day: day, weekForPicker: weekPicker.selectedSegmentIndex, dayForPicker: dayPicker.selectedSegmentIndex))
                week = swipedRight.week
                day = swipedRight.day
                weekPicker.selectedSegmentIndex = swipedRight.weekForPicker
                dayPicker.selectedSegmentIndex = swipedRight.dayForPicker
                getCurrentLecturersData{}
                lecturersTableView.reloadData()
                
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                let swipedLeft = GesturesUtil.gesturesForFullTimeTimeTablesAdding(data: GesturesClass(week: week, day: day, weekForPicker: weekPicker.selectedSegmentIndex, dayForPicker: dayPicker.selectedSegmentIndex))
                week = swipedLeft.week
                day = swipedLeft.day
                weekPicker.selectedSegmentIndex = swipedLeft.weekForPicker
                dayPicker.selectedSegmentIndex = swipedLeft.dayForPicker
                getCurrentLecturersData{}
                lecturersTableView.reloadData()
                
            default:
                break
            }
        }
    }

}


extension LecturersTimeTableController:UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    
    
    //PickerView:
    func enableLecturersPickerView(){
        let lecturersPicker=UIPickerView()
        lecturersPicker.delegate = self
        searchTextField.inputView = lecturersPicker

        //for showing first lecturer from array default:
        searchTextField.text=lecturersNames[0]
        chosenLecturer=lecturersNames[0]
        chosenLecturerEmail=emails[0]
        chosenLecturerInfo=info[0]
        chosenLecturerWebsite = websites[0]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lecturersNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lecturersNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenLecturer = lecturersNames[row]
        chosenLecturerEmail = emails[row]
        chosenLecturerInfo = info[row]
        chosenLecturerWebsite = websites[row]
        searchTextField.text = chosenLecturer
    }
    
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    
    //TableView:
    
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
}

