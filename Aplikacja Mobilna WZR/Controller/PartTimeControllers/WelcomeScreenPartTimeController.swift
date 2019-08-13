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
    let pleaseWaitLabelTexts = ["Trwa sprawdzanie połączenia...","Trwa usuwanie istniejących danych...","Trwa pobieranie danych... \n Może to potrwać kilkanaście sekund",]
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        changeLabel(number: 0)
        checkIfHasFavoriteGroup()
        checkConnection()
    }
 

    
    
    
    //Download Functions
    func getGroupsData(){
        
        changeLabel(number: 1)

        // smth to delete existing data
        let realm = try! Realm()
        let objects = realm.objects(PartTimeTimeTablesDataBase.self)
        let objects2 = realm.objects(NoticeBoardsDataBase.self)
        let objects3 = realm.objects(LecturersDataBase.self)
        try! realm.write {
            realm.delete(objects) // deleting existing PartTimeTimeTablesDataBase
            realm.delete(objects2.filter("FTorPT = 'PartTime' ")) // deleting existing NoticeBoardDataBase for PartTime Students
            realm.delete(objects3) // deleting existing lecturers database
        }
        
        changeLabel(number: 2)
        
        _=Groups(URLAdresses: AllURLs.partTimeGroups, groupsStartsWith: "N", completionHandler: { (tempArray) in
            self.userDefaults.set(tempArray, forKey: "partTimeGroupsList")
            
            PartTimeDownloadCSV(groupsArray: tempArray, completionHandler: {
                
                SendLecturersToRealm(completionHandler: {
                    
                    self.userDefaults.set(CurrentDate.getCurrentDate(), forKey: "dateOfLastRefreshPartTime")
                    self.performSegue(withIdentifier: "PartTimeInitialSegue", sender: self)
                    
                }).sendToRealm()
                
            }).getCSVDatatoDatabase()
            
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
            perform(#selector(showAlert), with: nil, afterDelay: 0) // showing alert, after delay 0, because otherwise will be error in viewDidLoad
        }
    }
    
    //if no connection functions
    @objc func showAlert(){
        Alerts.init(view: self, title: "Brak połączenia", message: "sprawdź swoje połączenie internetowe", option1title: "Spróbuj ponownie", option1Action: tryAgain, option2title: "kontynuuj offilne", option2Action: goOffilne).showAlertWithTwoOptions()
    }
    func tryAgain(){
        viewDidAppear(true)
    }
    func goOffilne(){
        performSegue(withIdentifier: "PartTimeInitialSegue", sender: self)
    }
    
    
    //checking if there is need to reload data -> is first time app is lounched or reload button was pressed
    func checkingIfNeedToReload(){
        
        guard let _ = userDefaults.string(forKey: "isNeededToReloadPartTime") else{
            self.userDefaults.set("isSet", forKey: "isNeededToReloadPartTime")
            self.getGroupsData()
            return
        }
        
        print("Dane już w pamięci")
        performSegue(withIdentifier: "PartTimeInitialSegue", sender: self)
    }
    
    //function for change label:
    
    func changeLabel(number:Int){
        pleaseWaitLabel.text=pleaseWaitLabelTexts[number]
    }
    
}
