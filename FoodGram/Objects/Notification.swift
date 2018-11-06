//
//  Notification.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Notification: NSObject {

    var createdBy: UUID
    var content: String
    var type: String
    var status: String
    
    init(createdBy: UUID, content: String, type: String, status: String) {
        self.createdBy = createdBy
        self.content = content
        self.type = type
        self.status = status
    }
}
