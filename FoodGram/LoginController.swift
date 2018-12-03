//
//  LoginController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-21.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase
import AwaitKit
import NotificationBannerSwift

class LoginController: UIViewController {
    
    var database: MyDatabase!
    var ref: DatabaseReference!

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!

    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    fileprivate func loadingData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (self.database.hasLoaded > 0)
            {
                self.performSegue(withIdentifier: "showTab",sender: self)
            } else {
                self.loadingData()
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
            self.database = MyDatabase.shared
            self.database.thisUserDBContext = user.uid
            

            self.database.readFriendPosts()
            self.database.readAllUsers()
            
            let banner = NotificationBanner(title: "Succesfully logged in.", subtitle: nil, style: .success)
            banner.show()

            self.loadingData()
            
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
                self.database.readAllUsers()
                
                let banner = NotificationBanner(title: "User created succesfully", subtitle: "Logging in...", style: .success)
                banner.show()
                
                self.performSegue(withIdentifier: "showTab",sender: self)
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
