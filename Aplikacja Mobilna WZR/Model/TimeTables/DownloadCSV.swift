//
//  DownloadCSV.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class DownloadCSV{
    
    //variables:
    let baseURL1:String = "https://wzr.ug.edu.pl/.csv/plan_st.php?f1="
    let baseURL2:String = "&f2=4"
    var groupsArray:[String]
    var completionHandler: ()->Void
    
    init(completionHandler: @escaping ()->Void, groupsArray:[String]) {
        self.groupsArray=groupsArray
        self.completionHandler=completionHandler
        
        getCsvDataToDatabase()

    }
    
    func getCsvDataToDatabase(){
        print(groupsArray)
        for x in groupsArray{
            let url:String = baseURL1+x+baseURL2
            ParseCSV(url: url, groupName: x)
            
            // wywołanie klasy parsującej csv-ki, przekazanie jej url + nazwę grupy
            // wyrzucenie z niej tablic z potrzebnymi rzeczmi
            // dodanie go do CoreData + dodanie "x" jako nazwa grupy
            
            
            //zrobić specjalny widok na pobieranie danych
            
            
        }
        completionHandler()
    }
}
