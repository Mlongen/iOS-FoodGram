//
//  User.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class AppUser: NSObject {

    var userId: UUID
    var userName: String
    var password: String
    var dateOfCreation: Date
    var email: String
    var profileImg: UIImage
    var friends: [Friend]
    var notifications: [Notification]
    
    init(userId: UUID, userName: String, password: String, dateOfCreation: Date, email: String, profileImg: UIImage, friends: [Friend], notifications: [Notification]) {
        self.userId = userId
        self.userName = userName
        self.password = password
        self.dateOfCreation = dateOfCreation
        self.email = email
        self.profileImg = profileImg
        self.friends = [Friend]()
        self.notifications = [Notification]()
    }
    
}
