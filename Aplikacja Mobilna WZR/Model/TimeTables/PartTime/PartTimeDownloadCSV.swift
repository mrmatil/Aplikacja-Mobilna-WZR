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
        
        let data = RemoveDuplicates.removePT(data: temp)
        
        if data.count>0{ // if in case that some groups may have no classes
            for x in 0...data.count-1{
                let ptdb = PartTimeTimeTablesDataBase()
                ptdb.group=data[x].group
                ptdb.className=data[x].className
                ptdb.lecturer=data[x].lecturer
                ptdb.startHour=data[x].startHour
                ptdb.endHour=data[x].endHour
                ptdb.classroom=data[x].classroom
                ptdb.date=data[x].date
                ptdb.nameOfTheDay=data[x].nameOfTheDay
                
                try! realm.write {
                    realm.add(ptdb)
                    datesArray.append(data[x].date)
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
        uniqueDatesArray = CurrentDate.getDatesInOrder(dates: uniqueDatesArray)
//        uniqueDatesArray = uniqueDatesArray.sorted()
        userDefaults.set(uniqueDatesArray, forKey: "datesList")
    }
}
