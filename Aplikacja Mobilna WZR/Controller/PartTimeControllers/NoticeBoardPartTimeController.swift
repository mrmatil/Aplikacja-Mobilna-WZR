//
//  NoticeBoardPartTimeController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 18/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class NoticeBoardPartTimeController: UIViewController {
    
    
    //variables:
    var level:Int=1
    var titles = [String]()
    var content = [String]()
    let userDefaults = UserDefaults()
    
    //IBOutlets:
    @IBOutlet weak var lastRefreshDateLabel: UILabel!
    @IBOutlet weak var noticeBoardTableView: UITableView!
    
    
    //IBActions:
    @IBAction func levelSegmentedControlPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            level=1
            getNoticeBoardDataFromRealm{}
            noticeBoardTableView.reloadData()
        }else{
            level=2
            getNoticeBoardDataFromRealm{}
            noticeBoardTableView.reloadData()
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        userDefaults.removeObject(forKey: "isNeededToReloadPartTime")
        print("pop to refresh")
        self.view.window?.rootViewController?.presentedViewController!.dismiss(animated: true, completion: nil)
    }
    
    
    //Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        getNoticeBoardDataFromRealm {
            self.enableTableView()
        }
        refreshLastDate()
        // Do any additional setup after loading the view.
    }
    
    func refreshLastDate(){
        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshPartTime") else {
            lastRefreshDateLabel.text = "Nigdy nie odświeżono"
            return
        }
        lastRefreshDateLabel.text = "Dane z dnia: \(temp)"
    }
    
    func getNoticeBoardDataFromRealm(completionHandler:@escaping ()->Void){
        titles=[String]()
        content=[String]()
        GetDataFromDatabaseNoticeBoard(FTorPT: "PartTime", level: level) { (results) in
            if results.count>0{
                for x in results{
                    self.titles.append(x.title ?? "")
                    self.content.append(x.content ?? "")
                }
                completionHandler()
            }
            }.getNoticeBoardsData()
    }
    
}

extension NoticeBoardPartTimeController:UITableViewDelegate, UITableViewDataSource{
    
    func enableTableView(){
        noticeBoardTableView.delegate = self
        noticeBoardTableView.dataSource = self
        noticeBoardTableView.register(UINib(nibName: "NoticeBoardCustomCell", bundle: nil), forCellReuseIdentifier: "CustomNoticeBoardCell")
        noticeBoardTableView.estimatedRowHeight = 85.0
        noticeBoardTableView.rowHeight = UITableView.automaticDimension
        noticeBoardTableView.separatorStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomNoticeBoardCell", for: indexPath) as! NoticeBoardCustomCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentLabel.text=content[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
