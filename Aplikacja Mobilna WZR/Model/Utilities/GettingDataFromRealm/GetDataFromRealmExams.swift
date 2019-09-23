//
//  GetDataFromRealmExams.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 20/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class GetDataFromRealmExams{
    
    static func getLecturers()->[String]{
        let realm = try! Realm()
        let data = realm.objects(ExamsDataBase.self).sorted(byKeyPath: "lecturer", ascending: true)
        
        var lecturers = [String]()
        
        for x in data{
            lecturers.append(x.lecturer!)
        }
        
        return Array(Set(lecturers)).sorted()
    }
    
    static func getSubjects()->[String]{
        let realm = try! Realm()
        let data = realm.objects(ExamsDataBase.self).sorted(byKeyPath: "subject", ascending: true)
        
        var subjects = [String]()
        
        for x in data{
            subjects.append(x.subject!)
        }
        
        return Array(Set(subjects)).sorted()
    }
    
    static func getFromRealm(FullTimeorPartTime:String,group:String,lecturer:String,subject:String)->Results<ExamsDataBase>{
        
        var temp = ""
        
        
        if group != " " && group != ""{
            temp = temp + "group CONTAINS '\(group)'"
        } else{
            temp = temp + "group CONTAINS '\(FullTimeorPartTime)'"
        }
        if lecturer != " " && lecturer != ""{
            temp = temp + " AND "
            temp = temp + "lecturer CONTAINS '\(lecturer)'"
        }
        if subject != " " && subject != ""{
            temp = temp + " AND "
            temp = temp + "subject CONTAINS '\(subject)'"
        }
        
        let realm = try! Realm()
        
        print(temp)
        
        if temp != "" && temp != " "{
            let data = realm.objects(ExamsDataBase.self).filter(temp).sorted(byKeyPath: "subject", ascending: true)
            return data
        } else {
            let data = realm.objects(ExamsDataBase.self).sorted(byKeyPath: "lecturer", ascending: true).filter("group CONTAINS '\(FullTimeorPartTime)'")
            return data
        }
    }
}
