//
//  SendNoticeBoardsToRealm.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 06/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class SendNoticeBoardsToRealm{
    
    //variables:
    let urls:[String]
    let completionHandler:()->Void
    let FullTimeOrPartTime:String
    
    init(urls:[String],FullTimeOrPartTime:String,completionHandler:@escaping ()->Void) {
        self.urls=urls
        self.completionHandler=completionHandler
        self.FullTimeOrPartTime=FullTimeOrPartTime
    }
    
    func getAllNoticeBoards(){
        let realm = try! Realm()
        for temp in urls{
            DownloadNoticeBoard(url: temp) { (titleArray, contentArray) in
                
               //sending data to realm
            }
        }
    }
}
