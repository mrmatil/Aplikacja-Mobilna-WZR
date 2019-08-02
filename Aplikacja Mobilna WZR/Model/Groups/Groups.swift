//
//  Groups.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 16/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation


class Groups{
    
    let URLAdresses: [String:String]
    var arrayOfBachelorGroups:[String]?
    var arrayOfMasterGroups:[String]?
    var arrayOfAll:[String] = []
    var groupsStartsWith:String
    var completionHandler: ([String])->Void
    
    init(URLAdresses:[String:String], groupsStartsWith:String, completionHandler: @escaping ([String])->Void) {
        self.completionHandler = completionHandler
        self.URLAdresses=URLAdresses
        self.groupsStartsWith = groupsStartsWith
        _=GroupsParser(url: URLAdresses["1 stopień"]!, answerFunction: bachelorListOfGroups)
        _=GroupsParser(url: URLAdresses["2 stopień"]!, answerFunction: masterListOfGroups)
    }
    
    //funkcja przekazująca nazwy grup licencjackich do wspólnej tablicy
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
    
    //funkcja przekazująca nazwy grup magisterskich do wspólnej tablicy + przesyłająca do completion handlera pełną tablicę
    private func masterListOfGroups(array:[String]){
        var tempArray:[String]=[]
        for x in array{
            if x.starts(with: "\(groupsStartsWith)"){
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
