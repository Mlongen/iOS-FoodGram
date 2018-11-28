//
//  LoginController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-21.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var database: MyDatabase!
    var ref: DatabaseReference!

    @IBAction func signInBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: "marcelolongen@gmail.com", password: "123456") { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            self.database = MyDatabase.shared
            self.database.thisUserDBContext = user.uid
            self.database.readFriendPosts()
            
            self.performSegue(withIdentifier: "showTab",sender: self)
        }
        
    }
    
    @IBOutlet weak var createAccBtn: UIButton!
    
    
    @IBAction func createAccAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: "marcelolongen@gmail.com", password: "123456") { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            MyDatabase.shared.thisUserDBContext = user.uid
            MyDatabase.shared.addUserToDB(user)
            self.performSegue(withIdentifier: "showTab",sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)

        // Do any additional setup after loading the view.
    }
    


     
}
