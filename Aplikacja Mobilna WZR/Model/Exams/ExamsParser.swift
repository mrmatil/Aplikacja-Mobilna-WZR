//
//  ExamsParser.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 19/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import SwiftSoup

class ExamsParser{
    
    let url:String
    let completionHandler:([ExamsArray])->Void
    
    init(url:String, completionHandler: @escaping ([ExamsArray])->Void) {
        self.url=url
        self.completionHandler=completionHandler
    }
    
    func getData(){
        _=WebDataDownload(url: url, completionHandlerFunction: parseData)
    }
    
    private func parseData(data:String){
        
        var returnArrayExams = [ExamsArray]()
        
        let tempArray = data.components(separatedBy: "blok_tytul")
        
        for oneLecturer in tempArray{
            let temp = "<div class = \"blok_tytul"+oneLecturer
                
            let tempSubjectArray = temp.components(separatedBy: "blok_podtytul")
            
            //Getting Lecturer Name:
            var lecturer:String = ""
            
            do{
                let doc = try SwiftSoup.parse(temp)
                let tempLecturer = try doc.select(".blok_tytul")
                lecturer = try tempLecturer.text()
            }
            catch{
                print(error.localizedDescription)
            }
            
            //Getting exams details:
            
            for oneSubject in tempSubjectArray{
                
                let temporaryString = "<li class = \"blok_podtytul"+oneSubject
    
                do{
                    let doc = try SwiftSoup.parse(temporaryString)
                    
                    let subject:Elements = try doc.select(".blok_podtytul")
                    let groupsAndHours:Elements = try doc.select(".sz6")
                    let dates:Elements = try doc.select(".sz2")
                    let classroomsAndTermin:Elements = try doc.select(".sz10")
                    let EorZ:Elements = try doc.select(".sz8")
                    
                    var groupsAndHoursString = [String]()
                    for x in groupsAndHours{
                        groupsAndHoursString.append(try x.text())
                    }
                    
                    let (groups, hours) = ExamsParseUtil.groupsOrHours(data: groupsAndHoursString)
                    
                    var classroomsAndTerminString = [String]()
                    for x in classroomsAndTermin{
                        classroomsAndTerminString.append(try x.text())
                    }
                    
                    let (classrooms, termins) = ExamsParseUtil.classroomsOrTermin(data: classroomsAndTerminString)
                    
                    //Creating ExamsArray
                    if dates.count>0{
                        for x in 0...dates.count-1{
                            let array = ExamsArray(lecturer: lecturer,
                                                   subject: try subject.text(),
                                                   group: groups[x],
                                                   date: try dates[x].text(),
                                                   hour: hours[x],
                                                   classroom: classrooms[x],
                                                   zaliczenieOrEgzamin: try EorZ[x].text(),
                                                   number: termins[x])
//                            print(array)
                            returnArrayExams.append(array)
                        }
                    }
                    
                    
                }
                catch{
                    print(error.localizedDescription)
                }
            }
    

        }
        
        completionHandler(returnArrayExams)
    }
}
