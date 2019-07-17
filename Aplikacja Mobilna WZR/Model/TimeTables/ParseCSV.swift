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
        
        DaysOfTheWeek(completionHandler: downloadData)
    }
    
    func downloadData(){
        WebDataDownload(url: url) { (stringCSV:String) in
            self.parsing(csv: stringCSV)
        }
    }
    
    func parsing(csv:String){
        do {
            let csv = try CSVReader(string: csv, hasHeaderRow: true)
            let headerRow = csv.headerRow!// header = ["Subject", "Start Date", "Start Time", "End Date", "End Time", "Description", "Location"]

            
            print(headerRow)
//            while let row = csv.next(){
//                print("\(row[0])")
//            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
