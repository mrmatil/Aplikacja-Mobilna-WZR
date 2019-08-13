//
//  LecturersDetailsCell.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 13/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class LecturersDetailsCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
