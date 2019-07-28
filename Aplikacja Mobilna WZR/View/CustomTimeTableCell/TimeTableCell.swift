//
//  TimeTableCell.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 27/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class TimeTableCell: UITableViewCell {

    //IBOutlets:
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var lecturerName: UILabel!
    @IBOutlet weak var locationName: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
