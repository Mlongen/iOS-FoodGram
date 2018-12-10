//
//  CreateUserViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-12-10.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class CreateUserViewController: UIViewController {
    func loadFriends() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (MyDatabase.shared.hasLoadedFriends > 0)
            {
                MyDatabase.shared.readFriendsPosts()
                self.loadPosts()
            } else {
                self.loadFriends()
            }
        }
    }
    fileprivate func loadPosts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (MyDatabase.shared.hasLoadedPosts > 0)
            {
                self.performSegue(withIdentifier: "userNameCreated",sender: self)
            } else {
                
                self.loadPosts()
            }
        }
    }

    @IBAction func submitUserName(_ sender: Any) {
        if (userName.text != "") {
            MyDatabase.shared.setUserNameAfterCreation(username: userName.text!)
        }
        MyDatabase.shared.checkIfUsername(userID: MyDatabase.shared.thisUserDBContext, completion: { (userName) in
            if (userName == "Default") {
                let banner = NotificationBanner(title: "An error occurred, please check fields and try again", subtitle: nil, style: .success)
                banner.show()
            } else {
                MyDatabase.shared.readFriends()
                MyDatabase.shared.hotReload()
                self.loadFriends()
            }
        })
    }
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
