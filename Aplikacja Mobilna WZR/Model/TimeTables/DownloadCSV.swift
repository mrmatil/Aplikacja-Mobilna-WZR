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
    let userDefaults = UserDefaults()
    var groupsArray:[String]
    var lecturersArray = [String]()
    var completionHandler: ()->Void
    var loopsCount:Int=0 // służy do sprawdzania ile już grup zostało przesłanych do bazy danych (każda grupa to +1 do aktualnej wartości)
    
    init(completionHandler: @escaping ()->Void, groupsArray:[String]) {
        self.groupsArray=groupsArray
        self.completionHandler=completionHandler
        
        getCsvDataToDatabase()

    }
    
    //pobieranie danych z klasy ParseCSV dla każdej grupy
    func getCsvDataToDatabase(){
        for x in groupsArray{
            
            let url:String = baseURL1+x+baseURL2
            _ = ParseCSV(url: url, groupName: x) { (tempArray) in
//               self.sendDataToDatabase(temp: tempArray)
                DispatchQueue.global(qos: .userInitiated).async {
                    self.sendDataToDatabase(temp: tempArray)
                }
            }
        }
        
    }
    
    //Przesyłanie danych jednej grupy do bazy danych w Realm
    func sendDataToDatabase(temp:[ClassesArray]){
        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL) //printowanie ścieżki do bazy danych realm
        for x in 0...temp.count-1{
            
            let db = TimeTablesDataBase()
            db.group=temp[x].group
            db.className=temp[x].className
            db.lecturer=temp[x].lecturer
            db.startHour=temp[x].startHour
            db.endHour=temp[x].endHour
            db.classroom=temp[x].classroom
            db.typeOfWeek=temp[x].typeOfWeek
            db.nameOfTheDay=temp[x].nameOfTheDay
            
            try! realm.write {
                realm.add(db)
                lecturersArray.append(db.lecturer ?? "")
            }
        }
        loopsCount += 1
        ifEnd()
    }
    
    // Funkcja służąca do wywołania completion handlera jeżeli ilość przesłanych grup = ilości całkowitej grup
    func ifEnd(){
        if loopsCount == groupsArray.count{
            sendLecturersToUserDefaults()
            completionHandler()
        }
    }
    
    //Funkcja przesyłająca do UserDefaults tablicę z wykładowcami bez powtórzeń
    func sendLecturersToUserDefaults(){
        let tempArray = Array(Set(lecturersArray))
        var uniqueLecturersArray = [String]()
        for temp in tempArray{
            if temp.contains(","){}
            else{
                uniqueLecturersArray.append(temp)
            }
        }
//        print(uniqueLecturersArray)
        userDefaults.set(uniqueLecturersArray, forKey: "lecturersList")
    }
}
