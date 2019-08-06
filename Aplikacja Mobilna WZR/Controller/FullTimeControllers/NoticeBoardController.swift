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
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
