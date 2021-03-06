//
//  ParseGroups.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 14/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import SwiftSoup

class GroupsParser{
    
    //variables:
    var answerFunction : ([String])->Void
    
    
    
    init(url:String, answerFunction: @escaping ([String])->Void) {
        self.answerFunction=answerFunction
        _=WebDataDownload.init(url: url, completionHandlerFunction: getData)
    }
    
        
    //funkcja "pobierająca" dane z "DownloadGroups":
    private func getData(Data:String){
        parseData(html: Data)
    }
    
    //funkcja parsująca tak by z całej strony internetowej pozostały tylko te będące w "option", czyli w tym przypadku nazwy grup:
    private func parseData(html:String){
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let groups: Elements? = try doc.select("option")
            let x = try groups!.text()
            _=returnArray(string: x)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //funkcja zmieniająca stringa z wypisanymi wszystkimi grupami na tablicę:
    private func returnArray(string:String)-> [String]{
        var arrayGroups: [String] = []
        var temp: String = ""
        
        for x in string{
            if x == " "{
                arrayGroups.append(temp)
                temp=""
            }
            else{
                temp = temp + "\(x)"
            }
        }
        arrayGroups.append(temp)
        answerFunction(arrayGroups)
        return arrayGroups
    }
}
