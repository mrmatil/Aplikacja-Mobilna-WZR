//
//  DownloadGroups.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import WebKit

class WebDataDownload{

    var completionHandlerFunction: (String) -> Void
    var urlString: String
    
    init(url:String,completionHandlerFunction: @escaping (String)->Void) {
        self.urlString=url
        self.completionHandlerFunction=completionHandlerFunction
        downloadHTMLData()
    }
    

    // Pobieranie całej strony internetowej do Stringa, po czym za pomocą completion handlera przekazywanie go dalej
    func downloadHTMLData(){
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            guard let data=data else{return}
            guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {return}
            
            self.completionHandlerFunction(htmlString)
        }
        task.resume()
    }
    
}
