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
    var completionHandler: (Results<TimeTablesDataBase>)->Void
    
    init(group:String, week:Int, day:String, completionHandler: @escaping (Results<TimeTablesDataBase>)->Void) {
        self.group=group
        self.week=week
        self.day=day
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
    
    
    
}
