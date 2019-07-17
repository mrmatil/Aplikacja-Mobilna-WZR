//
//  WelcomeScreenController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class WelcomeScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //zrobić funkcję czy jest internet
        downloadsInitializer()
        // Do any additional setup after loading the view.
    }
    
    func downloadsInitializer(){
        Groups() { (tempArray:[String]) in
//            print(tempArray)
            //przesyłanie tempArray do BazyDanych
            
            DownloadCSV(completionHandler: self.CSVDone, groupsArray: tempArray)
        }
    }
    
    func CSVDone(){
        
    }
    
    
}
