//
//  DownloadNoticeBoard.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 29/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import SwiftSoup

class DownloadNoticeBoard{
    
    //variables:
    var url:String?
    let completionHandler:([String],[String])->Void
    
    
    init(url:String, completionHandler:@escaping ([String],[String])->Void) {
        self.url=url
        self.completionHandler=completionHandler
    }
    
    
    func downloadWebsite(){
        _=WebDataDownload(url: url!, completionHandlerFunction: parseWebsite)
    }
    
    private func parseWebsite(data:String){
        do {
            let doc:Document = try SwiftSoup.parse(data)
            let titles:Elements = try doc.select(".blok_tytul")
            let contents:Elements = try doc.select(".ramka_tresc")
            
            var titleArray = [String]()
            for title:Element in titles.array(){
                titleArray.append(try title.text())
            }
            
            var contentsArray=[String]()
            for content:Element in contents.array(){
                contentsArray.append(try content.text())
            }

            print(titleArray)
            print(contentsArray)
            completionHandler(titleArray,contentsArray)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
