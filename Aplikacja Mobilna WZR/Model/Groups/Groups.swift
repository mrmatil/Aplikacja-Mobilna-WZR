//
//  Groups.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 16/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation


class Groups{
    
    let URLAdresses: [String:String] = ["1 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=437",
                                        "2 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=480"]
    var arrayOfBachelorGroups:[String]?
    var arrayOfMasterGroups:[String]?
    var arrayOfAll:[String] = []
    var completionHandler: ([String])->Void
    
    init(completionHandler: @escaping ([String])->Void) {
        self.completionHandler = completionHandler
        GroupsParser(url: URLAdresses["1 stopień"]!, answerFunction: bachelorListOfGroups)
        GroupsParser(url: URLAdresses["2 stopień"]!, answerFunction: masterListOfGroups)
    }
    
    private func bachelorListOfGroups(array:[String]){
        var tempArray:[String]=[]
        for x in array{
            if x.starts(with: "S"){
                tempArray.append(x)
            }
            else{
                continue
            }
        }

        arrayOfBachelorGroups = tempArray
        arrayOfAll += tempArray
    }
    
    private func masterListOfGroups(array:[String]){
        var tempArray:[String]=[]
        for x in array{
            if x.starts(with: "S"){
                tempArray.append(x)
            }
            else{
                continue
            }
        }
        
        arrayOfMasterGroups = tempArray
        
        arrayOfAll += tempArray
        completionHandler(arrayOfAll)
    }


    
}