//
//  PartTimeDownloadCSV.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 03/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class PartTimeDownloadCSV{
    
    //variables:
    let baseURL1:String = AllURLs.partTimeUrl[0]
    let baseURL2:String = AllURLs.partTimeUrl[1]
    let groupsArray:[String]
    var datesArray = [String]()
    let userDefaults = UserDefaults()
    var loopsCount:Int=0
    let completionHandler: ()->Void
    
    
    init(groupsArray:[String], completionHandler:@escaping ()->Void) {
        self.groupsArray=groupsArray
        self.completionHandler=completionHandler
    }
    
    func getCSVDatatoDatabase(){
        for x in groupsArray{
            let url = baseURL1+x+baseURL2
            _=PartTimeParseCSV(url: url, groupName: x, completionHandler: { (tempArray) in
                DispatchQueue.global(qos: .userInitiated).async {
                    self.sendDataToDatabase(temp: tempArray)
                }
            }).downloadData()
        }
    }
    
    //sending one group to realm database
    private func sendDataToDatabase(temp:[PartTimeClassesArray]){
        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL) //printowanie ścieżki do bazy danych realm
        if temp.count>0{ // if in case that some groups may have no classes
            for x in 0...temp.count-1{
                let ptdb = PartTimeTimeTablesDataBase()
                ptdb.group=temp[x].group
                ptdb.className=temp[x].className
                ptdb.lecturer=temp[x].lecturer
                ptdb.startHour=temp[x].startHour
                ptdb.endHour=temp[x].endHour
                ptdb.classroom=temp[x].classroom
                ptdb.date=temp[x].date
                ptdb.nameOfTheDay=temp[x].nameOfTheDay
                
                try! realm.write {
                    realm.add(ptdb)
                    datesArray.append(temp[x].date)
                }
            }
        }
        loopsCount += 1
        ifEnd()
    }
    
    private func ifEnd(){
        if loopsCount == groupsArray.count{
            sendDatesToUserDefaults()
            completionHandler()
        }
    }
    
    private func sendDatesToUserDefaults(){
        let temp = Array(Set(datesArray))
        var uniqueDatesArray = [String]()
        for x in temp{
            uniqueDatesArray.append(x)
        }
        uniqueDatesArray = uniqueDatesArray.sorted()
        userDefaults.set(uniqueDatesArray, forKey: "datesList")
    }
}
