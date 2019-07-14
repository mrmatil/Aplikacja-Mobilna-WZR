//
//  DownloadGroups.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import WebKit

class WzrGroupsDownload{

    var funcc: (String) -> Void
    
    init(funcc: @escaping (String)->Void) {
        self.funcc=funcc
        downloadHTMLData()
    }
    

    // Pobieranie całej strony internetowej do Stringa, po czym za pomocą completion handlera przekazywanie go do "ParseGroups"
    func downloadHTMLData(){
        let url = URL(string: "https://wzr.ug.edu.pl/studia/index.php?str=437")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
            guard let data=data else{return}
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {return}
            
            self.funcc(htmlString)
        }
        task.resume()
    }
    
}
