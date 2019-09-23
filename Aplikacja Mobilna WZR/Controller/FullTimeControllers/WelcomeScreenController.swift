//
//  WelcomeScreenController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie

class WelcomeScreenController: UIViewController {

    //variables
    let userDefaults = UserDefaults.standard // zmienna do przechowywania danych w user defaults
    let pleaseWaitLabelTexts = ["Trwa sprawdzanie połączenia...","Trwa usuwanie istniejących danych...","Trwa pobieranie danych... \n Może to potrwać kilkanaście sekund",]
    var loop=0
    
    //IBOutlets:
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    @IBOutlet weak var waitAnimationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startAnimation()
        changeLabel(number: 0)
        loop=0
        
        //checking if favorite group is set, if no is automaticly set to s11-01
        checkingIfHasFavoriteGroup()
        
        //checking if there is internet connection
        if Reachability.isConnectedToNetwork() {
            print("jest połączenie")
            checkingIfNeedToReload() //checking if needed to download data and if needed proceeds to download it
            
        }
        else{
            print("nie ma połączenia")
            perform(#selector(showAlert), with: nil, afterDelay: 0) // showing alert, after delay 0, because otherwise will be error in viewDidLoad
        }
        
    }
    
    // activated after checking in "checkingIfNeedToReload" if it should
    func downloadsInitializer(){
        
        changeLabel(number: 1)
        
        let realm = try! Realm()
        let objects = realm.objects(TimeTablesDataBase.self)
        let objects2 = realm.objects(NoticeBoardsDataBase.self)
        let objects3 = realm.objects(LecturersDataBase.self)
        let objects4 = realm.objects(ExamsDataBase.self)
        try! realm.write {
            realm.delete(objects) // deleting existing TimeTablesDataBase
            realm.delete(objects2.filter("FTorPT = 'FullTime' ")) // deleting existing NoticeBoardDataBase for FullTime Students
            realm.delete(objects3) // deleting existing lecturers database
            realm.delete(objects4.filter("group CONTAINS 'S' ")) // deleting exams database

        }
        
        changeLabel(number: 2)

        //Getting data from web
        
        _=Groups(URLAdresses: AllURLs.fullTimeGroups, groupsStartsWith: "S", completionHandler: { (tempArray) in
            self.userDefaults.set(tempArray, forKey: "groupsList") // sending list of all groups to UserDefaults
            if tempArray == []{
                self.showAlertNoGroups()
            }else{
                _=DownloadCSV(completionHandler: self.initCompleted, groupsArray: tempArray)
            }
        })
        
        SendNoticeBoardsToRealm(urls:  [AllURLs.fullTimeNoticeBoardsUrl["1 stopień"]!,AllURLs.fullTimeNoticeBoardsUrl["2 stopień"]!] , FullTimeOrPartTime: "FullTime", completionHandler: initCompleted).sendToRealm()
        
        SendLecturersToRealm(completionHandler: initCompleted).sendToRealm()
        
        SendExamsToRealm(url: [AllURLs.fullTimeExam1,AllURLs.fullTimeExam2], completionHandler: initCompleted).sendToRealm()

        
        //-----------------------
        
    }
    
    //performing segue after checking if all things is downloaded
    func initCompleted(){
        loop+=1
        if loop==4{ //change to 4 !!!!!!! 
            DispatchQueue.main.async {
                self.userDefaults.set(CurrentDate.getCurrentDate(), forKey: "dateOfLastRefreshFullTime")
                self.performSegue(withIdentifier: "initialSegue", sender: self)
            }
        }

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
    
    //checking if has already favorite group -> if not setting it to default value "S11-01" :
    func checkingIfHasFavoriteGroup(){
        guard let favGroup = userDefaults.string(forKey: "currentGroup") else {
            self.userDefaults.set("S11-01", forKey: "currentGroup") //POTENTIAL BUG IF SOMEONE WILL DELETE S11-01 GROUP !!!!
            return
        }
        print(favGroup)
    }
    
    
    //function for change label:
    
    func changeLabel(number:Int){
        pleaseWaitLabel.text=pleaseWaitLabelTexts[number]
    }
    
    //function for animations:
    
    func startAnimation(){
        waitAnimationView.animation = Animation.named("398-snap-loader-white")
        waitAnimationView.loopMode = .loop
        waitAnimationView.contentMode = .scaleAspectFit
        waitAnimationView.play()
    }
    
    //function if no plan
    func showAlertNoGroups(){
        Alerts.init(view: self,
                    title: "Brak Planu na stronie",
                    message: "Część funkcjonalności nie będzie dostępna",
                    option1title: "OK",
                    option1Action: initCompleted,
                    option2title: "",
                    option2Action: initCompleted).showAlertWithOneOption()
    }

}

