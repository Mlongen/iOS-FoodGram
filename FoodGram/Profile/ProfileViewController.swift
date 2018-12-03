//
//  ProfileViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private let reuseIdentifier = "ProfilePostCell"
    var thisUser: String = "test"
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userNameTitle: UINavigationItem!
    
    @IBOutlet weak var profilePostsCollection: UICollectionView!
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = thisUser
        self.title = thisUser
        // Do any additional setup after loading the view.
    }
    
}
