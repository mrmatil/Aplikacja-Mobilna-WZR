//
//  WelcomeScreenController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeScreenController: UIViewController {

    //variables
    let userDefaults = UserDefaults.standard // zmienna do przechowywania danych w user defaults
    
    //IBOutlets:
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking if favorite group is set, if no is automaticly set to s11-01
        checkingIfHasFavoriteGroup()
        
        //checking if there is internet connection
        if Reachability.isConnectedToNetwork(){
            print("jest połączenie")
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            downloadsInitializer()
        }
        else{
            print("nie ma połączenia")
            perform(#selector(showAlert), with: nil, afterDelay: 0) // showing alert, after delay 0, because otherwise will be error in viewDidLoad
        }
        
    }
    
    func downloadsInitializer(){
        _ = Groups() { (tempArray:[String]) in
            self.userDefaults.set(tempArray, forKey: "groupsList") // sending list of all groups to UserDefaults
            
            
            
            _=DownloadCSV(completionHandler: self.initCompleted, groupsArray: tempArray)
        }
    }
    
    func initCompleted(){
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
    
    
    //functions for if no connection:
    
    @objc func showAlert(){
        Alerts.init(view: self, title: "Brak połączenia", message: "sprawdź swoje połączenie internetowe", option1title: "Spróbuj ponownie", option1Action: tryAgain, option2title: "kontynuuj offilne", option2Action: goOffilne).showAlertWithTwoOptions()
    }
    func tryAgain(){
        viewDidLoad()
    }
    func goOffilne(){
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
    
    //checking if has already data:
    
    func checkingIfHasFavoriteGroup(){
        guard let favGroup = userDefaults.string(forKey: "currentGroup") else {
            self.userDefaults.set("S11-01", forKey: "currentGroup")
            return
        }
        print(favGroup)
    }
    
    func checkingIfHasListOfGroups(){
        //code
    }
    
    func checkingIfHasClassData(){
        //code
        
    }
}

