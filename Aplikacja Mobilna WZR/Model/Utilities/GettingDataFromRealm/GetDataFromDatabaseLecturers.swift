//
//  GetDataFromDatabaseLecturers.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 10/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import RealmSwift

class GetDataFromDatabaseLecturers{
    
    static func getData()->Results<LecturersDataBase>{
        let realm = try! Realm()
        let data = realm.objects(LecturersDataBase.self)
        return data
    }
}
