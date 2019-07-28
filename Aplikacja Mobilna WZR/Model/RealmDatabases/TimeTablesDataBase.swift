//
//  ClassesDB.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 27/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift


class TimeTablesDataBase:Object{
    @objc dynamic var group:String?
    @objc dynamic var className:String?
    @objc dynamic var lecturer:String?
    @objc dynamic var startHour:String?
    @objc dynamic var endHour:String?
    @objc dynamic var classroom:String?
    @objc dynamic var typeOfWeek:Int=0
    @objc dynamic var nameOfTheDay:String?
}
