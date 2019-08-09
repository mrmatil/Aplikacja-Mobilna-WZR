//
//  GesturesUtil.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 09/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class GesturesUtil{
    
    //FULL TIME:
    static func gesturesForFullTimeTimeTablesAdding(data:GesturesClass)->GesturesClass{
        let day = data.day
        var week = data.week
        let dayInt = data.dayForPicker
        var weekInt = data.weekForPicker
        
        switch day {
        case "poniedziałek":
            return GesturesClass(week: week, day: "wtorek", weekForPicker: weekInt, dayForPicker: dayInt+1)
        case "wtorek":
            return GesturesClass(week: week, day: "środa", weekForPicker: weekInt, dayForPicker: dayInt+1)
        case "środa":
            return GesturesClass(week: week, day: "czwartek", weekForPicker: weekInt, dayForPicker: dayInt+1)
        case "czwartek":
            return GesturesClass(week: week, day: "piątek", weekForPicker: weekInt, dayForPicker: dayInt+1)
        case "piątek":
            if week == 1{
                week = 2
                weekInt = 1
            }else{
                week = 1
                weekInt = 0
            }
            return GesturesClass(week: week, day: "poniedziałek", weekForPicker: weekInt, dayForPicker: 0)
        default:
            return GesturesClass(week: week, day: day, weekForPicker: weekInt, dayForPicker: dayInt)
        }
    }
    
    static func gesturesForFullTImeTablesDecreasing(data:GesturesClass)->GesturesClass{
        let day = data.day
        var week = data.week
        let dayInt = data.dayForPicker
        var weekInt = data.weekForPicker
        
        switch day {
        case "poniedziałek":
            if week == 1{
                week = 2
                weekInt = 1
            }else{
                week = 1
                weekInt = 0
            }
            return GesturesClass(week: week, day: "piątek", weekForPicker: weekInt, dayForPicker: 4)
        case "wtorek":
            return GesturesClass(week: week, day: "poniedziałek", weekForPicker: weekInt, dayForPicker: dayInt-1)
        case "środa":
            return GesturesClass(week: week, day: "wtorek", weekForPicker: weekInt, dayForPicker: dayInt-1)
        case "czwartek":
            return GesturesClass(week: week, day: "środa", weekForPicker: weekInt, dayForPicker: dayInt-1)
        case "piątek":
            return GesturesClass(week: week, day: "czwartek", weekForPicker: weekInt, dayForPicker: dayInt-1)
        default:
            return GesturesClass(week: week, day: day, weekForPicker: weekInt, dayForPicker: dayInt)
        }
    }
    
    
    //PART TIME:
    
    static func gesturesForPartTimeTimeTablesIncreasing(data:GesturesClassPartTime)->String{
        let array = data.allDates
        let currentData = data.currentDate
        var currentDataNumber:Int = 0
        
        for temp in 0...array.count-1{
            if array[temp] == currentData{
                currentDataNumber=temp
            }
        }
        
        if currentDataNumber+1<=array.count-1{
            return array[currentDataNumber+1]
        }else{
            return array[0]
        }
    }
    
    static func gesturesForPartTimeTimeTablesDecreasing(data:GesturesClassPartTime)->String{
        let array = data.allDates
        let currentData = data.currentDate
        var currentDataNumber:Int = 0
        
        for temp in 0...array.count-1{
            if array[temp] == currentData{
                currentDataNumber=temp
            }
        }
        
        if currentDataNumber-1>=0{
            return array[currentDataNumber-1]
        }else{
            return array[array.count-1]
        }
    }
    
}
