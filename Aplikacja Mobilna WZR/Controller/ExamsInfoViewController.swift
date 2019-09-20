//
//  ExamsInfoViewController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 20/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class ExamsInfoViewController: UIViewController {

    //variables
    var lecturer = [String]()
    var subject = [String]()
    var group = [String]()
    var date = [String]()
    var hour = [String]()
    var classroom = [String]()
    var zaliczenieOrEgzamin = [String]()
    var number = [String]()
    
    //IBOutlets:
    @IBOutlet weak var examsTableView: UITableView!
    
    //IBActions:
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableTableView()
    }
    

}
extension ExamsInfoViewController:UITableViewDelegate, UITableViewDataSource{
    
    func enableTableView(){
        examsTableView.delegate=self
        examsTableView.dataSource=self
        examsTableView.estimatedRowHeight = 80.0
        examsTableView.rowHeight = UITableView.automaticDimension
        examsTableView.register(UINib(nibName: "ExamsTableViewCell", bundle: nil), forCellReuseIdentifier: "customExamsCell")
        examsTableView.separatorStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lecturer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customExamsCell") as! ExamsTableViewCell
        cell.classroom.text = classroom[indexPath.row]
        cell.date.text = date[indexPath.row]
        cell.group.text = group[indexPath.row]
        cell.hour.text = hour[indexPath.row]
        cell.lecturer.text = lecturer[indexPath.row]
        cell.number.text = number[indexPath.row]
        cell.subject.text = subject[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
