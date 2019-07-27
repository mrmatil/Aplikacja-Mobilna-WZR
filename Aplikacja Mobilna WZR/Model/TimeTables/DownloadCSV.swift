//
//  DownloadCSV.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadCSV{
    
    //variables:
    let baseURL1:String = "https://wzr.ug.edu.pl/.csv/plan_st.php?f1="
    let baseURL2:String = "&f2=4"
    var groupsArray:[String]
    var completionHandler: ()->Void
    var loopsCount:Int=0
    
    init(completionHandler: @escaping ()->Void, groupsArray:[String]) {
        self.groupsArray=groupsArray
        self.completionHandler=completionHandler
        
        getCsvDataToDatabase()

    }
    
    func getCsvDataToDatabase(){
//        print(groupsArray)
        for x in groupsArray{
            
            let url:String = baseURL1+x+baseURL2
            _ = ParseCSV(url: url, groupName: x) { (tempArray) in
               self.sendDataToDatabase(temp: tempArray)
            }
            
            
            // wywołanie klasy parsującej csv-ki, przekazanie jej url + nazwę grupy
            // wyrzucenie z niej tablic z potrzebnymi rzeczmi
            // dodanie go do CoreData + dodanie "x" jako nazwa grupy
            
            
            //zrobić specjalny widok na pobieranie danych
            
            
        }
//        completionHandler()
    }
    
    func sendDataToDatabase(temp:[ClassesArray]){
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        for x in 0...temp.count-1{
            var db = TimeTablesDB()
            db.group=temp[x].group
            db.className=temp[x].className
            db.lecturer=temp[x].lecturer
            db.startHour=temp[x].startHour
            db.endHour=temp[x].endHour
            db.typeOfWeek=temp[x].typeOfWeek
            db.nameOfTheDay=temp[x].nameOfTheDay
            
            try! realm.write {
                realm.add(db)
            }
        }
        loopsCount += 1
        ifEnd()
    }
    
    func ifEnd(){
        if loopsCount == groupsArray.count{
            completionHandler()
        }
    }
}
