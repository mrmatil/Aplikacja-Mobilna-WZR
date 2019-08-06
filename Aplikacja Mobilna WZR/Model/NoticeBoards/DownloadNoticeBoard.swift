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
    let completionHandler:([noticeBoardArray])->Void
    let level:Int
    
    
    init(url:String, level:Int, completionHandler:@escaping ([noticeBoardArray])->Void) {
        self.url=url
        self.completionHandler=completionHandler
        self.level=level
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
            
            var array = [noticeBoardArray]()
            if contentsArray.count==titleArray.count && contentsArray.count != 0{
                for x in 0...contentsArray.count-1{
                    let temp = noticeBoardArray(title: titleArray[x],
                                             content: contentsArray[x],
                                             level: level)
                    array.append(temp)
                }
            }
            
            print(array)
            completionHandler(array)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
