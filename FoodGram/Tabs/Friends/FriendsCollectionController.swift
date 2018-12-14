//
//  FriendsCollectionController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Presentr
import SDWebImage
import Pastel

private let reuseIdentifier = "FriendCell"

class FriendsCollectionController: UICollectionViewController {
    @IBOutlet weak var pastelView: PastelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 26)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width / 4.8)
        
        // Custom Direction
        pastelView.startPastelPoint = .topRight
        pastelView.endPastelPoint = .bottomLeft
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
        pastelView.setColors([#colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.07936513195, green: 0.303920712, blue: 0.8549019694, alpha: 1)])
        
        pastelView.startAnimation()



    }
    lazy var searchController: SearchViewController = {
        let searchController = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")
        return searchController as! SearchViewController
    }()
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MyDatabase.shared.allUsers.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
    
        let index = indexPath.item
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true

        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.8)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.50
        cell.layer.opacity = 0.95
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        let usersArray = Array(MyDatabase.shared.allUsers)
        cell.userName.text = usersArray[index].key

        cell.newpic.setRounded()
        
        
        
        
        MyDatabase.shared.getProfilePicByID(userID: MyDatabase.shared.getUserIDByName(userName: usersArray[index].key)) { (urlStr) in
            if (urlStr == "image" || urlStr == "") {
                var newUrlStr = "https://firebasestorage.googleapis.com/v0/b/iosfoodgram.appspot.com/o/72EF94D0-10BA-4D0E-BBC3-90477B2600BE?alt=media&token=d44c9931-3096-44c2-9d10-37877990059b"
                let url = URL(string: newUrlStr)
                cell.newpic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                    cell.newpic.image = image
                })
            } else {
                let url = URL(string: urlStr)
                cell.newpic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                    cell.newpic.image = image
                })
            }
            
        }

        // Configure the cell
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FriendCell
        performSegue(withIdentifier: "detailFromFriendList", sender: cell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "detailFromFriendList") {
            if let dest = segue.destination as? ProfileViewController, let cell = sender as? FriendCell {
                dest.thisUserID = MyDatabase.shared.getUserIDByName(userName: cell.userName.text!)
}
}
}
}

extension UIImageView {
    
    func setRounded(borderWidth: CGFloat = 0.0, borderColor: UIColor = UIColor.clear) {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

