//
//  NoticeBoardCustomCell.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 06/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import UIKit

class NoticeBoardCustomCell: UITableViewCell {

    
    //variables:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
