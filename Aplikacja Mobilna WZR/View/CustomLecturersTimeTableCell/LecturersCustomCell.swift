//
//  LecturersCustomCell.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 29/07/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class LecturersCustomCell: UITableViewCell {

    
    //variables:
    @IBOutlet weak var startHour: UILabel!
    @IBOutlet weak var endHour: UILabel!
    @IBOutlet weak var group: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classroom: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
