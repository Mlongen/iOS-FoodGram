//
//  Notification.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Notification: NSObject {

    var notificationID: String
    var createdByUser: String
    var createdByID: String
    var content: String
    var type: String
    var creationDate: String
    var status: String
    
    init(notificationID: String, createdByUser: String, createdByID: String, content: String, type: String, creationDate: String, status: String) {
        self.notificationID = notificationID
        self.createdByUser = createdByUser
        self.createdByID = createdByID
        self.content = content
        self.creationDate = creationDate
        self.type = type
        self.status = status
    }
}
