//
//  SendExamsToRealm.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 19/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class SendExamsToRealm{
    
    let url:String
    let completionHandler:()->Void
    var loop = 0
    
    init(url:String,completionHandler: @escaping ()->Void) {
        self.url=url
        self.completionHandler=completionHandler
    }
    
    func sendToRealm(){
        ExamsParser.init(url: url) { (examsArray) in
            for x in examsArray{
                let realm = try! Realm()
                let db = ExamsDataBase()
                
                print(Realm.Configuration.defaultConfiguration.fileURL)
                
                
                db.lecturer=x.lecturer
                db.subject=x.subject
                db.classroom=x.classroom
                db.date=x.date
                db.hour=x.hour
                db.group=x.group
                db.zaliczenieOrEgzamin=x.zaliczenieOrEgzamin
                db.number=x.number
                
                try! realm.write {
                    realm.add(db)
                }
                
                self.loop += 1
                
                if self.loop == examsArray.count{
                    self.completionHandler()
                }
            }
        }.getData()
    }
    
}
