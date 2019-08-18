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
    let baseURL1:String = AllURLs.fullTimeUrl[0]
    let baseURL2:String = AllURLs.fullTimeUrl[1]
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
    private func sendDataToDatabase(temp:[ClassesArray]){
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL) //printowanie ścieżki do bazy danych realm
        
        //removing duplicates from classes array -> if two next lessons are the same and have no break between them it merges it into one lesson
        let data = RemoveDuplicates.removeFT(data: temp)
        
        
        for x in 0...data.count-1{
            
            let db = TimeTablesDataBase()
            db.group=data[x].group
            db.className=data[x].className
            db.lecturer=data[x].lecturer
            db.startHour=data[x].startHour
            db.endHour=data[x].endHour
            db.classroom=data[x].classroom
            db.typeOfWeek=data[x].typeOfWeek
            db.nameOfTheDay=data[x].nameOfTheDay
            
            try! realm.write {
                realm.add(db)
                lecturersArray.append(db.lecturer ?? "")
            }
        }
        loopsCount += 1
        ifEnd()
    }
    
    // Funkcja służąca do wywołania completion handlera jeżeli ilość przesłanych grup = ilości całkowitej grup
    private func ifEnd(){
        if loopsCount == groupsArray.count{
            sendLecturersToUserDefaults()
            completionHandler()
        }
    }
    
    //Funkcja przesyłająca do UserDefaults tablicę z wykładowcami bez powtórzeń
    private func sendLecturersToUserDefaults(){
        let tempArray = Array(Set(lecturersArray))
        var uniqueLecturersArray = [String]()
        for temp in tempArray{
            if temp.contains(","){}
            else{
                uniqueLecturersArray.append(temp)
            }
        }
        uniqueLecturersArray = uniqueLecturersArray.sorted()
//        print(uniqueLecturersArray)
        userDefaults.set(uniqueLecturersArray, forKey: "lecturersList")
    }
}
