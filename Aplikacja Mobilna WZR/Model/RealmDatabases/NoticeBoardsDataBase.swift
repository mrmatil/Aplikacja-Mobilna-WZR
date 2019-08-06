//
//  NoticeBoardsDataBase.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 06/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class NoticeBoardsDataBase:Object{
    @objc dynamic var title:String?
    @objc dynamic var content:String?
    @objc dynamic var level:Int=0
    @objc dynamic var FTorPT:String?
}
