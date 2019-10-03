//
//  LecturersUtil.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 03/10/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class LecturersUtil{
    
    static func getUrl(url:String)->String{
        
        let basicWebsite:String = "https://wzr.ug.edu.pl"

        if url.hasPrefix(".."){
            let x = url.components(separatedBy: "..")
            return basicWebsite + x[1]
        }else{
            return basicWebsite+url
        }
    
    }
    
    static func getTrueName(name:String)->String{
        
        var goodName = name
        
        if name.contains(","){
            let oneNameArray = name.components(separatedBy: ", ")
            goodName = oneNameArray[1] + ", " + oneNameArray[0]
            if goodName.contains("nadzw."){
                let anotherOneNameArray = goodName.components(separatedBy: "nadzw.")
                goodName = anotherOneNameArray[0] + "nadz" + anotherOneNameArray[1]
            }
        }
        
        return goodName
    }
    
    
}
