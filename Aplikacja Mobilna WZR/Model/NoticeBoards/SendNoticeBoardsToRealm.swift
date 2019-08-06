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
    var level:Int=1
    var loopsCount=0
    
    init(urls:[String],FullTimeOrPartTime:String,completionHandler:@escaping ()->Void) {
        self.urls=urls
        self.completionHandler=completionHandler
        self.FullTimeOrPartTime=FullTimeOrPartTime
    }
    
    func sendToRealm(){
        for temp in urls{
            DownloadNoticeBoard(url: temp, level: level) { (array) in
                for x in array{
                    let realm = try! Realm()
                    let db = NoticeBoardsDataBase()
                    db.title=x.title
                    db.content=x.content
                    db.level=x.level
                    db.FTorPT=self.FullTimeOrPartTime
                    
                    try! realm.write {
                        realm.add(db)
                    }
                }
            }.downloadWebsite()
            loopsCount+=1
            level+=1
            ifEnd()
        }
    }
    
    func ifEnd(){
        if loopsCount==2{
            completionHandler()
        }
    }
}
