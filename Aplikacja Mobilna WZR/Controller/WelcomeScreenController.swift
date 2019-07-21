//
//  WelcomeScreenController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

    let groupsList = UserDefaults.standard // zmienna do przechowywania danych w user defaults

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //zrobić funkcję czy jest internet
        downloadsInitializer()
        // Do any additional setup after loading the view.
    }
    
    func downloadsInitializer(){
        Groups() { (tempArray:[String]) in
            print(tempArray)
            //przesyłanie tempArray do BazyDanych
            self.groupsList.set(tempArray, forKey: "groupsList")
            
            
            
            DownloadCSV(completionHandler: self.CSVDone, groupsArray: tempArray)
        }
    }
    
    func CSVDone(){
        performSegue(withIdentifier: "initialSegue", sender: self)
    }
    
    
}
