//
//  LecturersTimeTableController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 28/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift

class LecturersTimeTableController: UIViewController {

    //variables:
    var LecturersArray = [String]()
    var chosenLecturer:String = ""
    var week:Int = 1 // 1 -> pierwszy tydzień, 2 -> drugi tydzień
    var day: String =  "poniedziałek"
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var classroom = [String]()
    var group = [String]()
    let userDefaults=UserDefaults()
    
    //IBOutlets:
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var lecturersTableView: UITableView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tempArray = userDefaults.array(forKey: "lecturersList") else {return}// pobieranie listy Wykładowców z UserDefaults + obsługa błędów w razie gdyby nie było danych
        LecturersArray = tempArray as! [String]
        enableLecturersPickerView()
        getCurrentLecturersData {
            self.enableTableView()
        }
        // Do any additional setup after loading the view.
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


}


extension LecturersTimeTableController:UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{

    
    
    //PickerView:
    func enableLecturersPickerView(){
        let lecturersPicker=UIPickerView()
        lecturersPicker.delegate = self
        searchTextField.inputView = lecturersPicker
        //for showing first lecturer from array default:
        searchTextField.text=LecturersArray[0]
        chosenLecturer=LecturersArray[0]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LecturersArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LecturersArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenLecturer = LecturersArray[row]
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

