//
//  TimeTableController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class TimeTableController: UIViewController {

    //variables:    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //IBOutlets:
    
    //IBActions:
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        print(userDefaults.string(forKey: "currentGroup")!)
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    

}
