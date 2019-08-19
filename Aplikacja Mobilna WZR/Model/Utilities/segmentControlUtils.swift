//
//  segmentControlUtils.swift
//  segmentControlTest
//
//  Created by Mateusz Łukasiński on 19/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import BetterSegmentedControl

class segmentControlUtils{
    
    static func getColours(array:[String],segmentControl:BetterSegmentedControl)->BetterSegmentedControl{
        segmentControl.segments = LabelSegment.segments(withTitles: array,
                                                              normalBackgroundColor: .clear,
                                                              normalFont: UIFont(name: "HelveticaNeue-Light", size: 16.0),
                                                              normalTextColor: UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0),
                                                              selectedBackgroundColor: UIColor(red: 24.0/255.0, green: 62.0/255.0, blue: 116.0/255.0, alpha: 1.0),
                                                              selectedFont: UIFont(name: "HelveticaNeue-Bold", size: 16.0),
                                                              selectedTextColor: .white)
        segmentControl.cornerRadius = 15.0
        
        return segmentControl
    }
}
