//
//  ExamsParseUtil.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 19/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class ExamsParseUtil{
    
    static func groupsOrHours(data:[String]) -> (groupsArray:[String], datesArray:[String]){
        
        var groups = [String]()
        var hours = [String]()
        
        for x in data{
            if x.hasPrefix("gr.:"){
                groups.append(x)
            }
            else if x.hasPrefix("godz.:"){
                hours.append(x)
            }
            else{
                continue
            }
        }
        
        return (groups,hours)
    }
    
    static func classroomsOrTermin(data:[String]) -> (classroomsArray:[String], terminArray:[String]){
        
        var classrooms = [String]()
        var termins = [String]()
        
        for x in data{
            if x.hasPrefix("sala"){
                classrooms.append(x)
            }
            else if x.hasPrefix("termin"){
                termins.append(x)
            } else{
                continue
            }
        }
        
        return(classrooms,termins)
    }
    
    
}
