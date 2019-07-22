//
//  WelcomeScreenController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

    //variables
    let groupsList = UserDefaults.standard // zmienna do przechowywania danych w user defaults
    
    //IBOutlets:
    @IBOutlet weak var pleaseWaitLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checking if there is internet connection
        if Reachability.isConnectedToNetwork(){
            print("jest połączenie")
            downloadsInitializer()
        }
        else{
            print("nie ma połączenia")
            perform(#selector(showAlert), with: nil, afterDelay: 0)
        }
        
    }
    
    func downloadsInitializer(){
        Groups() { (tempArray:[String]) in
            self.groupsList.set(tempArray, forKey: "groupsList") // sending list of all groups to UserDefaults
            
            
            
            DownloadCSV(completionHandler: self.initCompleted, groupsArray: tempArray)
        }
    }
    
    func initCompleted(){
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
    
    
    //functions for no connection:
    
    @objc func showAlert(){
        Alerts.init(view: self, title: "Brak połączenia", message: "sprawdź swoje połączenie internetowe", option1title: "Spróbuj ponownie", option1Action: tryAgain, option2title: "kontynuuj offilne", option2Action: goOffilne).showAlertWithTwoOptions()
    }
    func tryAgain(){
        viewDidLoad()
    }
    func goOffilne(){
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
}
