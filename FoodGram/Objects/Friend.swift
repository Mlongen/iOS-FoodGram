//
//  Friends.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class Friend: NSObject {
    var friendUserID: UUID
    var status: String
    
   init(friendUserID: UUID, status: String) {
        self.friendUserID = friendUserID
        self.status = status
    }
}
