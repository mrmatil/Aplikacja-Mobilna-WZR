//
//  ExamsDataBase.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 19/09/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class ExamsDataBase:Object{
    @objc dynamic var lecturer:String?
    @objc dynamic var subject:String?
    @objc dynamic var group:String?
    @objc dynamic var date:String?
    @objc dynamic var hour:String?
    @objc dynamic var classroom:String?
    @objc dynamic var zaliczenieOrEgzamin:String?
    @objc dynamic var number:String?
}
