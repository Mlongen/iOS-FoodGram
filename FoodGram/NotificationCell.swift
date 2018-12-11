//
//  NotificationCell.swift
//  FoodGram
//Cell
//  Created by Marcelo Longen on 2018-11-28.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var notificationContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationContent.text = "default"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }

}
