//
//  GetDataFromDatabase.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 28/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class GetDataFromDatabase{
    
    //variables:
    var group:String
    var week:Int
    var day: String
    var lecturer: String
    var completionHandler: (Results<TimeTablesDataBase>)->Void

    
    //Dla Widoku Grup:
    init(group:String, week:Int, day:String, completionHandler: @escaping (Results<TimeTablesDataBase>)->Void) {
        self.group=group
        self.week=week
        self.day=day
        self.lecturer = ""
        self.completionHandler=completionHandler
    }
    
    func getData(){
        do {
            let realm = try Realm()
            let data = realm.objects(TimeTablesDataBase.self).filter("group = '\(group)' AND typeOfWeek = \(week) AND nameOfTheDay = '\(day)'")
            completionHandler(data)
            
        } catch {
            print(error.localizedDescription)
            
        }
    }
    
    
    //Dla Widoku Wykładowców:
    
    init(lecturer:String, week:Int, day:String, completionHandler: @escaping (Results<TimeTablesDataBase>)->Void ) {
        self.lecturer=lecturer
        self.week=week
        self.day=day
        self.group = ""
        self.completionHandler=completionHandler
    }
    
    func getDataLecturers(){
        do {
            let realm = try Realm()
            let data = realm.objects(TimeTablesDataBase.self).filter("lecturer CONTAINS '\(lecturer)' AND typeOfWeek = \(week) AND nameOfTheDay = '\(day)'").sorted(byKeyPath: "startHour", ascending: true)
            completionHandler(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
}
