//
//  Database.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class MyDatabase: NSObject {
    static let shared = MyDatabase()
    var thisUserDBContext: String
    var selfPosts: [Post]
    var friendPosts: [Post]
    var notifications: [Notification]
    
    init(thisUserDBContext: String = "0") {
        
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friendPosts = [Post]()
        self.notifications = [Notification]()
    }
    
    
    func addFriendPosts()
    {
        let newPost = Post(postId: UUID(), userId: UUID(), image: UIImage(named: "placeholder"), postDescription: "lala", creationDate: Date(), price: 10, location: "location", rating: 8, likes: [UUID()])
        
        friendPosts.append(newPost)
    }
}
