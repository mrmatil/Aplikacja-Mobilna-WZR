//
//  LecturersDetailsController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import SafariServices

class LecturersDetailsController: UIViewController {

    //Variables:
    var titles:[String] = ["Imię i Nazwisko:","E-mail:","Informacje:"] //titles for cells in table view
    var detailsArray:[String?] = [] //array of name, email and info
    var website:String = ""
    
    //IBOutlets
    @IBOutlet weak var lecturersInfoTableView: UITableView!
    
    //IBFunctions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: website)!)
        present(svc, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(detailsArray)
        enableTableView()
    }
    

}

extension LecturersDetailsController:UITableViewDelegate,UITableViewDataSource{

    func enableTableView(){
        lecturersInfoTableView.delegate=self
        lecturersInfoTableView.dataSource=self
        lecturersInfoTableView.register(UINib(nibName: "LecturersDetailsCell", bundle: nil), forCellReuseIdentifier: "lecturersDetailsCell")
        lecturersInfoTableView.estimatedRowHeight = 80.0
        lecturersInfoTableView.rowHeight = UITableView.automaticDimension
        lecturersInfoTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lecturersDetailsCell") as! LecturersDetailsCell
        cell.title.text=titles[indexPath.row]
        cell.body.text=detailsArray[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
