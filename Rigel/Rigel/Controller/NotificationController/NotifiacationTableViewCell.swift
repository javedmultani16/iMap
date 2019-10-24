//
//  NotifiacationTableViewCell.swift
//  Rigel
//
//  Created by Javed Multani on 23/10/2019.
//  Copyright © 2019 Javed Multani. All rights reserved.
//

import UIKit

class NotifiacationTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
