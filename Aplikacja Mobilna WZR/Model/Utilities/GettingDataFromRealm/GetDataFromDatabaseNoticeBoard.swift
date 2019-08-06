//
//  GetDataFromDatabaseNoticeBoard.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 06/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class GetDataFromDatabaseNoticeBoard{
    
    //variables:
    var FTorPT:String
    var level:Int
    let completionHandler:(Results<NoticeBoardsDataBase>)->Void
    
    init(FTorPT:String,level:Int,completionHandler:@escaping (Results<NoticeBoardsDataBase>)->Void) {
        self.FTorPT=FTorPT
        self.level=level
        self.completionHandler=completionHandler
    }
    
    func getNoticeBoardsData(){
        do {
            let realm = try Realm()
            let data = realm.objects(NoticeBoardsDataBase.self).filter("level = \(level) AND FTorPT = '\(FTorPT)' ")
            completionHandler(data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
