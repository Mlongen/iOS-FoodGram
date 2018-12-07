//
//  NotificationViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-28.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource {
    
    
    
//    @IBAction func acceptFriendRequest(_ sender: NotificationCell) {
//
////        var userName = sender.notificationContent.text?.split(separator: " ")[0]
//        print(sender.notificationContent.text)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDatabase.shared.notifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.notificationContent.text = MyDatabase.shared.notifications[indexPath.row].content
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(acceptFriendRequest), for: .touchUpInside)
        return cell
    }
    
    @objc func acceptFriendRequest(sender: UIButton){
        let content = MyDatabase.shared.notifications[sender.tag].content
        let userName = String(content.split(separator: " ")[0])
        MyDatabase.shared.addUserAsFriend(userName: userName)
    }
    
}

extension NotificationViewController: UITableViewDelegate {

}
