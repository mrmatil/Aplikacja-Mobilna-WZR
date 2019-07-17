//
//  ParsingCSVutilities .swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class ParsingUtil{
    
    static func changingStringToDate(date:String, hour:String)->Date{
        let fullDate=date+"/"+hour
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM/dd/yyyy/HH.mm"
        guard let date = dateFormatter.date(from: fullDate) else {return Date.init()}
        return date
    }
    
    static func numberOfWeek(date:String, hour:String)->Int{
        let fullDate=date+"/"+hour
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM/dd/yyyy/HH.mm"
        guard let temp = dateFormatter.date(from: fullDate) else {return 0}
        let myCalendar = Calendar(identifier: .gregorian)
        let numberOfWeek = myCalendar.component(.weekOfYear, from: temp)
        
        //jeżeli nie jest podzielny przez 2 to drugi tydzień
        if numberOfWeek % 2 == 0 {
            return 1 // tydzień pierwszy
        }else{
            return 2 // tydzień drugi
        }
    }
    
    static func nameOfTheDay(date:String, hour:String)->String{
        let fullDate=date+"/"+hour
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM/dd/yyyy/HH.mm"
        guard let temp = dateFormatter.date(from: fullDate) else {return ""}
        let myCalendar = Calendar(identifier: .gregorian)
        let numberOfWeek = myCalendar.component(.weekday, from: temp) // 2-poniedziałek, 3-wtorek, 4-środa, 5-czwartek, 6-piątek, 7-sobota, 1-niedziela
        
        switch numberOfWeek {
        case 2:
            return "poniedziałek"
        case 3:
            return "wtorek"
        case 4:
            return "środa"
        case 5:
            return "czwartek"
        case 6:
            return "piątek"
        default:
            return ""
        }
    }
}
