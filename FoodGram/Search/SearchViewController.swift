//
//  SearchViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import RAMReel
import NotificationBannerSwift

class SearchViewController: UIViewController,UICollectionViewDelegate {
    static var thisSearchController = SearchViewController()
    var dataSource: SimplePrefixQueryDataSource!
    var data: [String]!
    var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!
    var result: String!

    lazy var profileViewController: ProfileViewController = {
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        return profileViewController as! ProfileViewController
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        SearchViewController.thisSearchController = self
        data = Array(MyDatabase.shared.allUsers.keys)
        dataSource = SimplePrefixQueryDataSource(data)
        
        ramReel = RAMReel(frame: view.bounds, dataSource: dataSource, placeholder: "Start by typing…", attemptToDodgeKeyboard: false)
        ramReel.hooks.append {
            self.result = $0
            if (self.data.contains(self.result)) {
                self.profileViewController.thisUserID = MyDatabase.shared.getUserIDByName(userName: self.result)
                self.navigationController?.pushViewController(self.profileViewController, animated: true)

            } else {
                let banner = NotificationBanner(title: "User \(self.result!) does not exist", subtitle: nil, style: .danger)
                banner.show()
            }
        }
        
        view.addSubview(ramReel.view)

    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if (segue.identifier == "showProfileFromSearch") {
//            if let dest = segue.destination as? ProfileViewController{
//                dest.thisUser = self.result
//            }
//
//}
//}
}
