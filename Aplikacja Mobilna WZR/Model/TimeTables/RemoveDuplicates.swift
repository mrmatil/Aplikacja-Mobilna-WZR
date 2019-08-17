//
//  RemoveDuplicates.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 16/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class RemoveDuplicates{
    
    static func removeFT(data:[ClassesArray])->[ClassesArray]{
        
        //variables:
        let weeks:[Int] = [1,2]
        let days:[String] = ["poniedziałek","wtorek","środa","czwartek","piątek"]
        
        var dataWithoutDuplicates = [ClassesArray]()
        for week in weeks{
            
            for day in days{
                //getting array of one day
                var tempArray = [ClassesArray]() //array of classes during one day without duplicates
                for x in data{
                    if x.nameOfTheDay==day && x.typeOfWeek==week{
                        tempArray.append(x)
                    }
                }
                
                //if more than one class during the day it is searching for "duplicates" and merging it
                if tempArray.count>1{
                    var temp:ClassesArray = tempArray[0]
                    for y in 0...tempArray.count-2{
                        if tempArray[y+1].className == temp.className && tempArray[y+1].classroom == temp.classroom && tempArray[y+1].lecturer == temp.lecturer{
                            
                            temp = ClassesArray(group: tempArray[y+1].group,
                                                className: tempArray[y+1].className,
                                                lecturer: tempArray[y+1].lecturer,
                                                startHour: temp.startHour,
                                                endHour: tempArray[y+1].endHour,
                                                classroom: tempArray[y+1].classroom,
                                                typeOfWeek: week,
                                                nameOfTheDay: day)
                            
                        }
                        else{
                            
                            dataWithoutDuplicates.append(temp)
                            temp = tempArray[y+1]
                            
                        }
                        
                    }
                    
                    dataWithoutDuplicates.append(temp)
                    
                }
                    
                // if only one class during the day it only append to array that one
                else if tempArray.count == 1{
                    dataWithoutDuplicates.append(tempArray[0])
                }
                
                //if there is no class during the day nothing happens
                
            }
            
        }
        
        
        return dataWithoutDuplicates
    }
}
