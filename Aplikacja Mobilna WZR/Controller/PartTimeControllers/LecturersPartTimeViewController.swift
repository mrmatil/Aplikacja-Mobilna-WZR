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
    var datesArray = [String]()
    var chosenLecturer:String = ""
    var chosenLecturerEmail:String = ""
    var chosenLecturerInfo:String = ""
    var chosenLecturerWebsite:String = ""
    var tempLecturer:String = ""
    var tempLecturerEmail:String = ""
    var tempLecturerInfo:String = ""
    var tempLecturerWebsite:String = ""
    var date:String=""
    var tempDate:String=""
    
    //Realm Timetable variables:
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var classroom = [String]()
    var group = [String]()
    //------------------------
    
    let userDefaults=UserDefaults()
    var lecturersPickerView: UIPickerView!
    var datesPickerView: UIPickerView!
    
    //Realm Lecturers variables:
    var lecturersNames = [String]()
    var emails = [String]()
    var info = [String]()
    var websites = [String]()
    //-------------------------
    
    
    //IBOutlets:
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var lecturerTextField: UITextField!
    @IBOutlet weak var lecturersTableView: UITableView!
    
    
    //IBActions
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        chosenLecturer=tempLecturer
        chosenLecturerEmail=tempLecturerEmail
        chosenLecturerInfo=tempLecturerInfo
        chosenLecturerWebsite=tempLecturerWebsite
        getCurrentLecturersData{}
        updateUI()
        endEditing()
    }
    
    @IBAction func detailsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "PTLecturersDetails", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLecturersArray()
        getDatesArray()
        if datesArray.count>0{
            getCurrentLecturersData {
                self.enableTableView()
                self.addLeftRight()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PTLecturersDetails"{
            let vc = segue.destination as! LecturersDetailsController
            vc.detailsArray.append(chosenLecturer)
            vc.detailsArray.append(chosenLecturerEmail)
            vc.detailsArray.append(chosenLecturerInfo)
            vc.website = chosenLecturerWebsite
        }
    }
    
    
    //getting data functions:
    
    func getLecturersArray(){
        let temp = GetDataFromDatabaseLecturers.getData()
        if temp.count>0{
            for x in 0...temp.count-1{
                lecturersNames.append(temp[x].name!)
                emails.append(temp[x].email!)
                info.append(temp[x].info!)
                websites.append(temp[x].website!)
            }
            chosenLecturer=lecturersNames[0]
            chosenLecturerEmail=emails[0]
            chosenLecturerInfo=info[0]
            chosenLecturerWebsite=websites[0]
            lecturerTextField.text=chosenLecturer
            enableLecturersPickerView()
        }
    }
    
    func getDatesArray(){
        guard let temp = userDefaults.array(forKey: "datesList") as? [String] else{return}
        datesArray = temp
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
                print("Swiped Right")
                
                let swipedRight = GesturesUtil.gesturesForPartTimeTimeTablesDecreasing(data: GesturesClassPartTime(allDates: datesArray, currentDate: date))
                date = swipedRight
                dateTextField.text=date
                
                getCurrentLecturersData {}
                lecturersTableView.reloadData()
                
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped Left")
                
                let swipedLeft = GesturesUtil.gesturesForPartTimeTimeTablesIncreasing(data: GesturesClassPartTime(allDates: datesArray, currentDate: date))
                date=swipedLeft
                dateTextField.text=date
                
                getCurrentLecturersData {}
                lecturersTableView.reloadData()
                
            default:
                break
            }
        }
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
            return lecturersNames.count
        }else{
            return datesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == lecturersPickerView{
            return lecturersNames[row]
        }else{
            return datesArray[row]+" ("+CurrentDate.nameOfTheDayPT(date: datesArray[row])+")"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == lecturersPickerView{
            tempLecturer = lecturersNames[row]
            tempLecturerEmail = emails[row]
            tempLecturerInfo = info[row]
            tempLecturerWebsite = websites[row]
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
