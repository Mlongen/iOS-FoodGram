//
//  Post.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Post: NSObject {
    var postId: String
    var userId: String
    var image: String
    var postDescription: String
    var creationDate: String
    var price: String
    var location: String
    var rating: Int
    var likes: [String]
    
    
    init(postId: String, userId: String, image: String, postDescription: String, creationDate: String, price: String, location: String, rating: Int) {
        self.postId = postId
        self.userId = userId
        self.image = image
        self.postDescription = postDescription
        self.creationDate = creationDate
        self.price = price
        self.location = location
        self.rating = rating
        self.likes = [String]()
    }

}
