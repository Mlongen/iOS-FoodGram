//
//  Database.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Database: NSObject {

    var thisUserDBContext: UUID
    var selfPosts: [Post]
    var friendPosts: [Post]
    var notifications: [Notification]
    
    init(thisUserDBContext: UUID) {
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friendPosts = [Post]()
        self.notifications = [Notification]()
    }
}
