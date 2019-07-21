//
//  ParseCSV.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import CSV

class ParseCSV{
    
    //variables:
    var url:String
    var groupName:String
    
    init(url:String, groupName:String){
        self.url=url
        self.groupName=groupName
        downloadData()
        }
    
    func downloadData(){
        WebDataDownload(url: url) { (stringCSV:String) in
            self.parsing(csv: stringCSV)
        }
    }
    
    func parsing(csv:String){

        do {
            let csv = try CSVReader(string: csv, hasHeaderRow: true)
//            let headerRow = csv.headerRow!// header = ["Subject", "Start Date", "Start Time", "End Date", "End Time", "Description", "Location"]
            while let row = csv.next(){
                // przesyłanie danych do do coreData
                let group:String = groupName
                let className:String = row[0]
                let lecturer:String = row[5]
                let startHour:String = row[2]
                let endHour:String = row[4]
                let typeOfWeek:Int = ParsingUtil.numberOfWeek(date: row[1], hour: row[2])
                let nameOfTheDay:String = ParsingUtil.nameOfTheDay(date: row[1], hour: row[2])
                print("Grupa: \(group), nazwa: \(className), prowadzący: \(lecturer), godzina rozpoczęcia: \(startHour), godzina zakończenia:\(endHour), typ tygodnia: \(typeOfWeek), nazwa dnia tygodnia: \(nameOfTheDay)")
                // dodanie do CoreData
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
