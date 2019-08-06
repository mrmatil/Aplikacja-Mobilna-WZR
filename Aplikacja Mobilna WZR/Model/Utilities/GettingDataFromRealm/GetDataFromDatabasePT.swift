//
//  GetDataFromDatabasePT.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 05/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class GetDataFromDatabasePT{
    
    //variables
    var group: String
    var date: String
    var lecturer: String
    let completionHandler: (Results<PartTimeTimeTablesDataBase>)->Void
    
    init(group:String,date:String,completionHandler:@escaping (Results<PartTimeTimeTablesDataBase>)->Void) {
        self.group=group
        self.date=date
        self.lecturer=""
        self.completionHandler=completionHandler
    }
    
    //normal Time table:
    
    func getData(){
        do {
            let realm = try Realm()
            let data = realm.objects(PartTimeTimeTablesDataBase.self).filter("group = '\(group)' AND date = '\(date)'")
            completionHandler(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //lecturers Time table:
    
    init(lecturer:String,date:String,completionHandler:@escaping (Results<PartTimeTimeTablesDataBase>)->Void) {
        self.group=""
        self.date=date
        self.lecturer=lecturer
        self.completionHandler=completionHandler
    }
    
    func getLecturersData(){
        do {
            let realm = try Realm()
            let data = realm.objects(PartTimeTimeTablesDataBase.self).filter("lecturer CONTAINS '\(lecturer)' AND date = '\(date)'")
            completionHandler(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
