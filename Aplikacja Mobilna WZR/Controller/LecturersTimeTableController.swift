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
//    var LecturersArray:[String]
    
    //IBOutlets:
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lecturersTableView: UITableView!
    
    
    //UIActions:
    @IBAction func weekPickerChanged(_ sender: UISegmentedControl) {
    }
    @IBAction func dayPickerChanged(_ sender: UISegmentedControl) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getLecturersList(){
        do {
            let realm = try Realm()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    

}
