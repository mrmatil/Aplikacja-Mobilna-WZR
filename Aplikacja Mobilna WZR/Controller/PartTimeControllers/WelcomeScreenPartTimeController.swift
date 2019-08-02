//
//  WelcomeScreenPartTimeController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 02/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeScreenPartTimeController: UIViewController {

    
    //variables
    let userDefaults = UserDefaults()
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        checkIfHasFavoriteGroup()
        checkConnection()
        
        // Do any additional setup after loading the view.
    }
 

    
    
    
    //Download Functions
    func getGroupsData(){
        
        // smth to delete existing data
        
        _=Groups(URLAdresses: AllURLs.partTimeGroups, groupsStartsWith: "N", completionHandler: { (tempArray) in
            self.userDefaults.set(tempArray, forKey: "partTimeGroupsList")
            
            self.performSegue(withIdentifier: "PartTimeInitialSegue", sender: self.self) //temporary
        })
    }
    
    
    // Check Functions
    
    //checking if user previously set his favorite group, if not it automaticly sets to N11-01
    func checkIfHasFavoriteGroup(){
        
        guard let favGroup = userDefaults.string(forKey: "currentGroupPartTime") else{
            userDefaults.set("N11-01", forKey: "currentGroupPartTime")
            return
        }
        print("Your favorite group: \(favGroup)")
    }
    
    //checking connection
    func checkConnection(){
        
        if Reachability.isConnectedToNetwork(){
            print("Jest Połączenie")
            checkingIfNeedToReload()
        }else{
            print("Nie ma Połączenia")
        }
    }
    
    //checking if there is need to reload data -> is first time app is lounched or reload button was pressed
    func checkingIfNeedToReload(){
        
        guard let _ = userDefaults.string(forKey: "isNeededToReloadPartTime") else{
//            self.userDefaults.set("isSet", forKey: "isNeededToReloadPartTime")
            self.getGroupsData()
            return
        }
        
        print("Dane już w pamięci")
        performSegue(withIdentifier: "initialPartTimeSeguey", sender: self)
    }
    


    
}
