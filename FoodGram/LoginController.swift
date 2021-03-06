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
import FBSDKLoginKit
import Pastel

class LoginController: UIViewController, FBSDKLoginButtonDelegate  {
    
    
    var database: MyDatabase!
    var ref: DatabaseReference!
    var userChecked: NSInteger!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var passwordField: UITextField!
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
                
                
                MyDatabase.shared.checkIfUsername(userID: user.uid, completion: { (userName) in
                    if (userName == "Default") {
                        self.performSegue(withIdentifier: "createUserName",sender: self)
                    } else {
                        MyDatabase.shared.readFriends()
                        MyDatabase.shared.hotReload()
                        self.loadFriends()
                    }
                })
                
                let banner = NotificationBanner(title: "Succesfully logged in.", subtitle: nil, style: .success)
                banner.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    banner.dismiss()
                })
            }
        }
    }
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    @IBAction func createAccAction(_ sender: Any) {
        
        let email = emailField?.text
        let password = passwordField?.text
        
        
        if (email != nil),(password != nil) {
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                // ...
                guard let user = authResult?.user else { return }
                MyDatabase.shared.thisUserDBContext = user.uid
                MyDatabase.shared.addUserToDB(user, username: "Default")
                // send to other viewcontroller later
                //                MyDatabase.shared.readFriends()
                //                MyDatabase.shared.hotReload()
                self.loadFriends()
                
                let banner = NotificationBanner(title: "User created succesfully", subtitle: "Logging in...", style: .success)
                banner.show()
                
                self.performSegue(withIdentifier: "createUserName",sender: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    banner.dismiss()
                })
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .topRight
        pastelView.endPastelPoint = .bottomLeft
        
        // Custom Duration
        pastelView.animationDuration = 5.0
        
        // Custom Color
        pastelView.setColors([#colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.07936513195, green: 0.303920712, blue: 0.8549019694, alpha: 1)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        userChecked = 0
        self.navigationController?.setToolbarHidden(true, animated: false)
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height/1.48)
        loginButton.readPermissions = ["email"]
        loginButton.layer.opacity = 0.90
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
        
        if FBSDKAccessToken.current() != nil {
            fbLogin()
        }
    }
    
    fileprivate func fbLogin() {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            guard let user = authResult?.user else { return }
            MyDatabase.shared.thisUserDBContext = user.uid
            if self.userChecked == 0 {
                MyDatabase.shared.checkIfUserExists(email: user.email!, completion: { (exists) in
                    if exists {
                        MyDatabase.shared.checkIfUsername(userID: user.uid, completion: { (userName) in
                            self.userChecked = self.userChecked + 1
                            if (userName == "Default") {
                                self.performSegue(withIdentifier: "createUserName",sender: self)
                            } else {
                                MyDatabase.shared.readFriends()
                                MyDatabase.shared.hotReload()
                                self.loadFriends()
                            }
                        })
                    } else if MyDatabase.wasUserNameChecked == 1 {
                        MyDatabase.shared.addUserToDB(user, username: "Default")
                        self.loadFriends()
                        self.userChecked = self.userChecked + 1
                        let banner = NotificationBanner(title: "User created succesfully", subtitle: "Logging in...", style: .success)
                        banner.show()
                        
                        self.performSegue(withIdentifier: "createUserName",sender: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            banner.dismiss()
                        })
                    }
                })
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                fbLogin()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}

