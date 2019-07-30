//
//  SettingsController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 30/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    //userDefaults variable:
    let userDefaults = UserDefaults()
    
    //IBOutlets:
    @IBOutlet weak var lastRefreshDate: UILabel!
    
    //IBActions:
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        print("pop to refresh")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        print("pop to inital")
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshLastDate()
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshFullTime") else {
//            lastRefreshDate.text = "Nigdy nie odświeżono"
//            return
//        }
//        lastRefreshDate.text = temp
//    }
    
    //functions:
    
    func refreshLastDate(){
        guard let temp = userDefaults.string(forKey: "dateOfLastRefreshFullTime") else {
            lastRefreshDate.text = "Nigdy nie odświeżono"
            return
        }
        lastRefreshDate.text = temp
    }
    


}
