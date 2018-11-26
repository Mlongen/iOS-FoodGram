//
//  User.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class AppUser: NSObject {

    var userId: String
    var userName: String
    var dateOfCreation: Date
    var email: String
    var profileImg: String
    var friends: [Friend]
    var notifications: [Notification]
    
    init(userId: String, userName: String, dateOfCreation: Date, email: String, profileImg: String, friends: [Friend], notifications: [Notification]) {
        self.userId = userId
        self.userName = userName
        self.dateOfCreation = dateOfCreation
        self.email = email
        self.profileImg = profileImg
        self.friends = [Friend]()
        self.notifications = [Notification]()
    }
    
}
