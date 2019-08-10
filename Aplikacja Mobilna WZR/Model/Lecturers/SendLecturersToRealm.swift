//
//  SendLecturersToRealm.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 10/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class SendLecturersToRealm{
    
    let url:String = AllURLs.lecturersInfoUrl
    let completionHandler:()->Void
    var loops:Int=0
    
    init(completionHandler:@escaping ()->Void) {
        self.completionHandler=completionHandler
    }
    
    func sendToRealm(){

        LecturersParser(url: url) { (array) in
            for x in array{
                let realm = try! Realm()
                let db = LecturersDataBase()
                db.name=x.name
                db.email=x.email
                db.info=x.info
                
                try! realm.write {
                    realm.add(db)
                }
                
                self.loops+=1
                
                if self.loops == array.count{
                    self.completionHandler()
                }
            }
        }.getData()
    }
    

}
