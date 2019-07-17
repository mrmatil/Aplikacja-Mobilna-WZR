//
//  DaysOfTheWeek.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 17/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import CSV

class DaysOfTheWeek{
    
    //variables:
    let url:String = "https://wzr.ug.edu.pl/.csv/plan_st.php?f1=S11-02&f2=4"
    var completionHandler: ()->Void
    
    init(completionHandler:@escaping ()->Void) {
        self.completionHandler=completionHandler
        downloadDays()
    }
    
    func downloadDays(){
        WebDataDownload(url: url, completionHandlerFunction: getDays)
    }
    
    
    func getDays(csv:String){
        do {
            let csvS1102 = try CSVReader(string: csv ,hasHeaderRow: true)
            
            print(csvS1102.currentRow)
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
