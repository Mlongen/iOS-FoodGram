//
//  PostController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-16.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class PostController: UITableViewCell {

    @IBOutlet weak var postCell: TimelinePostCell!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
