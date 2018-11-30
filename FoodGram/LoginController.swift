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

class LoginController: UIViewController {
    
    var database: MyDatabase!
    var ref: DatabaseReference!

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!

    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func signInBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: "marcelolongen@gmail.com", password: "123456") { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            self.database = MyDatabase.shared
            self.database.thisUserDBContext = user.uid
            

            self.database.readFriendPosts()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if (self.database.hasLoaded > 0)
                {
                    self.performSegue(withIdentifier: "showTab",sender: self)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if (self.database.hasLoaded > 0)
                        {
                            self.performSegue(withIdentifier: "showTab",sender: self)
                        } else {
                            
                        }
                    }
                }
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
