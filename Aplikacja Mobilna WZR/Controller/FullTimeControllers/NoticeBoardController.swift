//
//  NoticeBoardController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 06/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift

class NoticeBoardController: UIViewController {

    //variables
    var level:Int=1
    var titles = [String]()
    var content = [String]()
    
    //IBOutlets:
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
            print("dupa")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNoticeBoardDataFromRealm {
            self.enableTableView()
        }
        // Do any additional setup after loading the view.
    }
    
    
//    GettingData:
    
    func getNoticeBoardDataFromRealm(completionHandler:@escaping ()->Void){
        titles=[String]()
        content=[String]()
        GetDataFromDatabaseNoticeBoard(FTorPT: "FullTime", level: level) { (results) in
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

extension NoticeBoardController:UITableViewDataSource,UITableViewDelegate{
    
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
