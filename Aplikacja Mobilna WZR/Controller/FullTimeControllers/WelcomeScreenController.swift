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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //checking if favorite group is set, if no is automaticly set to s11-01
        checkingIfHasFavoriteGroup()
        
        //checking if there is internet connection
        if Reachability.isConnectedToNetwork() {
            
            print("jest połączenie")
            checkingIfNeedToReload() //checking if needed to download data
            
        }
        else{
            print("nie ma połączenia")
            perform(#selector(showAlert), with: nil, afterDelay: 0) // showing alert, after delay 0, because otherwise will be error in viewDidLoad
        }
        
    }
    
    func downloadsInitializer(){
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll() // deleting existing data
        }
        
        _ = Groups() { (tempArray:[String]) in
            self.userDefaults.set(tempArray, forKey: "groupsList") // sending list of all groups to UserDefaults
            
            
            
            _=DownloadCSV(completionHandler: self.initCompleted, groupsArray: tempArray)
        }
    }
    
    func initCompleted(){
        userDefaults.set(CurrentDate.getCurrentDate(), forKey: "dateOfLastRefreshFullTime")
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
    
    
    
    //Utilities functions:
    
    
    //checking if needed to download data or just perform segue
    func checkingIfNeedToReload(){
        guard let _ = userDefaults.string(forKey: "isNeededToReloadFullTime") else{
            self.userDefaults.set("true", forKey: "isNeededToReloadFullTime")
            downloadsInitializer()
            return
        }
        print("Dane już w pamięci")
        performSegue(withIdentifier: "initialSegue", sender: self)
        
    }
    
    //functions for if no connection:
    
    @objc func showAlert(){
        Alerts.init(view: self, title: "Brak połączenia", message: "sprawdź swoje połączenie internetowe", option1title: "Spróbuj ponownie", option1Action: tryAgain, option2title: "kontynuuj offilne", option2Action: goOffilne).showAlertWithTwoOptions()
    }
    func tryAgain(){
        viewDidAppear(true)
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
}

