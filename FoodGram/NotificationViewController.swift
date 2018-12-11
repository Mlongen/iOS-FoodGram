//
//  NotificationViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-28.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import NotificationBannerSwift



class NotificationViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
//    @IBAction func acceptFriendRequest(_ sender: NotificationCell) {
//
////        var userName = sender.notificationContent.text?.split(separator: " ")[0]
//        print(sender.notificationContent.text)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyDatabase.shared.notificationsTableView = tableView
        return MyDatabase.shared.filteredNotifications.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.userNameLabel.text = MyDatabase.shared.filteredNotifications[indexPath.row].createdByUser
        
        var usernameLength = ((cell.userNameLabel.text?.count)!) + 1
        var content = MyDatabase.shared.filteredNotifications[indexPath.row].content
        
        var startIndex = content.index(content.startIndex, offsetBy: usernameLength)
        cell.notificationContent.text = String(content[startIndex...])
        
        MyDatabase.shared.getProfilePicByID(userID:MyDatabase.shared.filteredNotifications[indexPath.row].createdByID) { (urlStr) in
            let url = URL(string: urlStr)
            cell.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                cell.profilePic.image = image
            })
            cell.profilePic.setRounded()
        }
        
        let notificationID =
            MyDatabase.shared.filteredNotifications[indexPath.row].notificationID
        let status = MyDatabase.shared.filteredNotifications[indexPath.row].status
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(acceptFriendRequest), for: .touchUpInside)
        MyDatabase.shared.setNotificationAsRead(notificationId: notificationID, status: status)
        
        
        return cell
    }

    @objc func acceptFriendRequest(sender: UIButton){
        let thisNotification =  MyDatabase.shared.filteredNotifications[sender.tag]
        let content = thisNotification.content
        let notificationId = thisNotification.notificationID
        let userName = String(content.split(separator: " ")[0])
        MyDatabase.shared.addUserAsFriend(userName: userName)
        
        MyDatabase.shared.setNotificationAccepted(notificationId: notificationId)
        self.dismiss(animated: true, completion: nil)
        MyDatabase.shared.removeNotification(notification: thisNotification)
        tableView.reloadData()
        let banner = NotificationBanner(title: "\(userName) is now your friend", style: .success)
        
        banner.show()
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            banner.dismiss()
        
    })
    }
}

extension NotificationViewController: UITableViewDelegate {
}

