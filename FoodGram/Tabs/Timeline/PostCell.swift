//
//  PostCell.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var foodPic: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var likes: UILabel!
}
