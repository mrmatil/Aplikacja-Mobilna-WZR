//
//  AllURLs.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 02/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation

class AllURLs{
    
    //Groups:
    
    //FullTime
    static let fullTimeGroups:[String:String] = ["1 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=437",
                                                 "2 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=480"]
    //PartTime
    static let partTimeGroups:[String:String] = ["1 stopień":"https://wzr.ug.edu.pl/studia/?str=462",
                                                 "2 stopień":"https://wzr.ug.edu.pl/studia/?str=486"]
    
    //Timetables:
    
    //FullTime
    static let fullTimeUrl: [String] = ["https://wzr.ug.edu.pl/.csv/plan_st.php?f1=","&f2=4"]
    
    //PartTime
    static let partTimeUrl: [String] = ["https://wzr.ug.edu.pl/.csv/plan_st.php?f1=","&f2=4"]
    
    //NoticeBoards:
    
    //FullTime
    static let fullTimeNoticeBoardsUrl:[String:String]=["1 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=438",
                                                        "2 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=481"]
    //PartTime
    static let partTimeNoticeBoardsUrl:[String:String]=["1 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=463",
                                                        "2 stopień":"https://wzr.ug.edu.pl/studia/index.php?str=487"]
    
    
    
    //LecturersInfo:
    static let lecturersInfoUrl:String = "https://wzr.ug.edu.pl/wydzial/index.php?str=121"
     
}
