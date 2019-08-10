//
//  lecturersDataBase.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 10/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class LecturersDataBase:Object{
    @objc dynamic var name:String?
    @objc dynamic var email:String?
    @objc dynamic var info:String?
}
