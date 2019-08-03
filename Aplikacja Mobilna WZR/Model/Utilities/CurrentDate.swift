//
//  CurrentDate.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 29/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class CurrentDate{
    
    
    static func getCurrentTypeOfWeek() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: date)
        
        //jeżeli nie jest podzielny przez 2 to drugi tydzień
        if week % 2 == 0 {
            return 1 // tydzień pierwszy
        }else{
            return 2 // tydzień drugi
        }
    }
    
    static func getDayOfTheWeek() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        switch day {
        case 2:
            return "Poniedziałek"
        case 3:
            return "Wtorek"
        case 4:
            return "Środę"
        case 5:
            return "Czwartek"
        case 6:
            return "Piątek"
        case 7:
            return "Sobotę"
        case 1:
            return "Niedzielę"
        
        default:
            return "Błąd"
        }
    }
    
    static func getCurrentDate() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    static func nameOfTheDayPT(date:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        guard let temp = dateFormatter.date(from: date) else {return ""}
        let myCalendar = Calendar(identifier: .gregorian)
        let numberOfWeek = myCalendar.component(.weekday, from: temp) // 2-poniedziałek, 3-wtorek, 4-środa, 5-czwartek, 6-piątek, 7-sobota, 1-niedziela
        
        switch numberOfWeek {
        case 1:
            return "niedziela"
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
        case 7:
            return "sobota"
        default:
            return ""
        }
    }
}
