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
    var week:Int = 1 // 1 -> pierwszy tydzień, 2 -> drugi tydzień
    var day: String =  "poniedziałek"
    var startHour = [String]()
    var endHour = [String]()
    var className = [String]()
    var lecturer = [String]()
    var classroom = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //IBOutlets:
    @IBOutlet weak var SubjectsTableView: UITableView!
    
    //IBActions:
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        print(userDefaults.string(forKey: "currentGroup")!)
        performSegue(withIdentifier: "toSettings", sender: self)
        SubjectsTableView.reloadData()
    }
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
}




extension TimeTableController: UITableViewDelegate, UITableViewDataSource{
    
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
    
    
    
}

