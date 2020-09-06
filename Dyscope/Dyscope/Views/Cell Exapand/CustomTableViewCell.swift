//
//  CustomTableViewCell.swift
//  Dyscope
//
//  Created by Shreeniket Bendre on 9/5/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonMain: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
