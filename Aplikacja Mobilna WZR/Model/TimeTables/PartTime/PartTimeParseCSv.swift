//
//  PartTimeParseCSv.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 03/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import CSV

class PartTimeParseCSV{
    
    //variables:
    let groupName:String
    let url:String
    var partTimeClassessArray = [PartTimeClassesArray]()
    let completionHandler:([PartTimeClassesArray])->Void
    
    init(url:String,groupName:String,completionHandler:@escaping ([PartTimeClassesArray])->Void) {
        self.url=url
        self.groupName=groupName
        self.completionHandler=completionHandler
    }
    
    //getting CSV data from website using WebDataDownload Class
    func downloadData(){
        _=WebDataDownload(url: url) { (data) in
            self.parsingCSV(data: data)
        }
    }
    
    //parses CSV data and sending it back to PartTimeDownloadCSV
    private func parsingCSV(data:String){
        
        do {
            let csv = try CSVReader(string: data, hasHeaderRow: true)
            // header = ["Subject", "Start Date", "Start Time", "End Date", "End Time", "Description", "Location"]
            while let row = csv.next(){
                let group = groupName
                let className = row[0]
                let lecturer = row[5]
                let startHour = row[2]
                let endHour = row[4]
                let classroom = ParsingCsvUtil.classroom(location: row[6])
                let date = ParsingCsvUtil.changingStructureOfDate(date: row[1])
                let nameOfTheDay = ParsingCsvUtil.nameOfTheDay(date: row[1], hour: row[2])
                
                partTimeClassessArray.append(PartTimeClassesArray(group: group,
                                                                  className: className,
                                                                  lecturer: lecturer,
                                                                  startHour: startHour,
                                                                  endHour: endHour,
                                                                  classroom: classroom,
                                                                  date: date,
                                                                  nameOfTheDay: nameOfTheDay))
            }
        }
        catch  {
            print(error.localizedDescription)
        }
//        print(partTimeClassessArray)
        completionHandler(partTimeClassessArray)
    }
}
