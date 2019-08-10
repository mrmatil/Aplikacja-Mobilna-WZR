//
//  LecturersParser.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 10/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import SwiftSoup

class LecturersParser{
    
    //variables:
    let url:String
    let completionHandler:([LecturersArray])->Void
    
    init(url:String, completionHandler:@escaping ([LecturersArray])->Void) {
        self.url=url
        self.completionHandler=completionHandler
    }
    
    func getData(){
        _=WebDataDownload(url: url, completionHandlerFunction: parseData)
    }
    
    private func parseData(data:String){
        do {
            let doc = try SwiftSoup.parse(data)
            let names:Elements = try doc.select(".pracownik_b")
            let emails:Elements = try doc.select(".wizytowka_info .plink")
            let info:Elements = try doc.select(".konsultacje")

            //Lecturers Names:
            var namesArray = [String]()
            for name:Element in names.array(){
                namesArray.append(try name.text())
            }
//            print("Names:")
//            print("Names count:" + "\(namesArray.count)")
//            print(namesArray)
            
            //Lecturers Emails:
            var emailsArray = [String]()
            for email:Element in emails.array(){
                emailsArray.append(try email.text())
            }
//            print("Emails:")
//            print("Emails count:" + "\(emailsArray.count)")
//            print(emailsArray)
            
            //Lecturers Info:
            var infoArray = [String]()
            for info:Element in info.array(){
                infoArray.append(try info.text())
            }
//            print("Info")
//            print("Info count:" + "\(infoArray.count)")
//            print(infoArray)
            
            var dataArray = [LecturersArray]()
            if namesArray.count == emailsArray.count && emailsArray.count == infoArray.count && infoArray.count > 0{
                for x in 0...namesArray.count-1{
                    if namesArray[x].contains(","){
                        let oneNameArray = namesArray[x].components(separatedBy: ", ")
                        namesArray[x] = oneNameArray[1] + ", " + oneNameArray[0]
                    }
                    let temp = LecturersArray(name: namesArray[x], email: emailsArray[x], info: infoArray[x])
                    dataArray.append(temp)
                }
            }
            
            print(dataArray)
            completionHandler(dataArray)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
