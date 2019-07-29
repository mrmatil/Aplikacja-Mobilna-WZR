//
//  DownloadNoticeBoard.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 29/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class DownloadNoticeBoard{
    
    let baseURL:String = "https://wzr.ug.edu.pl/studia/index.php?str=438"
    
    func downloadData(){
        let _ = WebDataDownload(url: baseURL) { webData in
            //code 
        }
    }
}
