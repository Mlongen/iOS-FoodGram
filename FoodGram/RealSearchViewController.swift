//
//  RealSearchViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-12-10.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import GooglePlaces
import SDWebImage

class RealSearchViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var userSearchView: UIView!
    
    var selectedSegment: Int = 0
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 0
            self.collectionView.isHidden = false
        } else {
            self.collectionView.isHidden = true
           
        }
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyDatabase.shared.searchCollectionView = self.collectionView

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openRestaurantPicker(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    
}
extension RealSearchViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        MyDatabase.shared.findPostsByRestaurantname(searchedName: place.name)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension RealSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = MyDatabase.shared.searchResults.count
        if (count == 0) {
            self.collectionView.setEmptyMessage("Nothing to show :(")
        } else {
            self.collectionView.restore()
            self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        }
        return count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let database = MyDatabase.shared
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        let index = indexPath.item
        
        let userID = database.searchResults[index].userId
        //configure cell
        
        
        cell.userName.text = database.getUserById(userID:userID)
        cell.amount.text = database.searchResults[index].price
        cell.restaurantName.text = database.searchResults[index].location
        cell.descriptionLabel.text = database.searchResults[index].postDescription
        //        let size = cell.descriptionLabel.sizeThatFits(CGSize(width: (view.frame.size.width - 50), height: 50))
        //        cell.descriptionLabel.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: size)
        
        let imageUrl = database.searchResults[index].image
        let url = URL(string: imageUrl)
        cell.foodPic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            cell.foodPic.image = image
        })
        MyDatabase.shared.getProfilePicByID(userID: userID) { (urlStr) in
            let url = URL(string: urlStr)
            cell.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                cell.profilePic.image = image
            })
        }
        
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        let width = (view.frame.size.width - 20)
        cell.profilePic.setRounded()
        cell.rating.text = "Rating: " + String(database.searchResults[index].rating) + "/10"
        
        return cell
    }
    
    
    
}


extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 40
        return sizeThatFits
    }
}
