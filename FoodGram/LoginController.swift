//
//  LoginController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-21.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class LoginController: UIViewController {
    
    var database: MyDatabase!
    var ref: DatabaseReference!

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!

    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    fileprivate func loadFriends() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (MyDatabase.shared.hasLoadedFriends > 0)
            {
                print(MyDatabase.shared.friends)
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
                self.performSegue(withIdentifier: "showTab",sender: self)
            } else {
                
                self.loadPosts()
            }
        }
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        let email = emailField?.text
        let password = passwordField?.text
        
        if (email != nil), (password != nil) {
        Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            MyDatabase.shared.thisUserDBContext = user.uid
            
            MyDatabase.shared.readFriends()
            MyDatabase.shared.readAllUsers()
            self.loadFriends()

            
            let banner = NotificationBanner(title: "Succesfully logged in.", subtitle: nil, style: .success)
            banner.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                banner.dismiss()
            })

           
            MyDatabase.shared.readNotifications()
            
            }
        }
    }
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    @IBAction func createAccAction(_ sender: Any) {
        
        let email = emailField?.text
        let username = userNameField?.text
        let password = passwordField?.text
        
        
        if (email != nil), (username != nil), (password != nil) {
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                // ...
                guard let user = authResult?.user else { return }
                MyDatabase.shared.thisUserDBContext = user.uid
                MyDatabase.shared.addUserToDB(user, username: username!)
                MyDatabase.shared.readFriends()
                MyDatabase.shared.readAllUsers()
                self.loadFriends()

                
                let banner = NotificationBanner(title: "User created succesfully", subtitle: "Logging in...", style: .success)
                banner.show()
                
                self.performSegue(withIdentifier: "showTab",sender: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    banner.dismiss()
                })
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
            confirmPasswordField.removeFromSuperview()
            confirmPasswordLabel.removeFromSuperview()
        // Do any additional setup after loading the view.
    }
     
}
