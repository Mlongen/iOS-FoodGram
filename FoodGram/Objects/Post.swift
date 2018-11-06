//
//  Post.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Post: NSObject {
    var postId: UUID
    var userId: UUID
    var image: UIImage?
    var postDescription: String
    var creationDate: Date
    var price: Int
    var location: String
    var likes: [UUID]
    
    
    init(postId: UUID, userId: UUID, image: UIImage?, postDescription: String, creationDate: Date, price: Int, location: String, likes: [UUID]) {
        self.postId = postId
        self.userId = userId
        self.image = image
        self.postDescription = postDescription
        self.creationDate = creationDate
        self.price = price
        self.location = location
        self.likes = [UUID]()
    }

}
