//
//  AddPostViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-07.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GooglePlaces
import GooglePlacePicker
import AVFoundation
import CoreServices
import YPImagePicker
import iOSDropDown
import Cosmos
import NotificationBannerSwift

class AddPictureControllerDelegate: AppDelegate {
    
}

class AddPostViewController: UIViewController, GMSPlacePickerViewControllerDelegate {
    var ref: DatabaseReference!
    var myDB: MyDatabase!
    var storageRef: StorageReference!

    var picker: YPImagePicker!
    weak var delegate: AddPictureControllerDelegate!
    @IBAction func pickPlace(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var amount: UISlider!
    @IBOutlet weak var rating: UISlider!

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var postDescription: UITextField!
    var pickedImage: UIImage!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var cameraBTN: UIButton! {
        didSet {
            cameraBTN.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        }
    }
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBAction func cameraBTNTapped(_ sender: Any) {
        self.presentImagePicker()
    }
    @IBOutlet weak var postButton: UIButton!
    
    
    
    @IBOutlet weak var dropDown: DropDown!
    var dropDownData: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownData = ["$5", "$10", "$15", "$20", "$30", "$35+"]
        dropDown.optionArray = dropDownData
        dropDown.listHeight = 300
        self.myDB = MyDatabase.shared
        ref = Database.database().reference().child("users").child(myDB.thisUserDBContext)
        self.storageRef = Storage.storage().reference()

        // The list of array to display. Can be changed dynamically
        // Do any additional setup after loading the view.
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        self.nameLabel.text = place.name
        
    }
    
    fileprivate func upload(_ image: UIImage, _ postId: String, _ userId: String, _ postDescription: String, _ formattedDate: String, _ price: String, _ location: String, _ rating: Int) {
        let imagePath = Storage.storage().reference().child(postId)
        if let imageData = image.pngData(){
            imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                // Fetch the download URL
                imagePath.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        // Get the download URL
                        let urlStr:String = (url?.absoluteString ?? "")
                        self.ref.child("posts").child(postId).child("userID").setValue(userId)
                        self.ref.child("posts").child(postId).child("image").setValue(urlStr)
                        self.ref.child("posts").child(postId).child("postDescription").setValue(postDescription)
                        self.ref.child("posts").child(postId).child("creationDate").setValue(formattedDate)
                        self.ref.child("posts").child(postId).child("price").setValue(price)
                        self.ref.child("posts").child(postId).child("location").setValue(location)
                        self.ref.child("posts").child(postId).child("rating").setValue(rating)
                    }
                }
                }
        }
    }
    
    @IBAction func addPost(_ sender: Any) {
        let postId = UUID().uuidString
        let userId = myDB.thisUserDBContext
        
        let postDescription = self.postDescription.text
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = formatter.string(from: creationDate)
        let price = dropDownData[dropDown.selectedIndex!]
        let location = self.nameLabel.text
        let rating = cosmosView.rating
    
        upload(cameraBTN.image(for: .normal)!, postId, userId, postDescription!, formattedDate, price, location!, Int(rating))
        let banner = NotificationBanner(title: "Post uploaded successfully!", subtitle: "Your friends will be able to see it in a few seconds.", style: .success)
        banner.show()
        self.dismiss(animated: true, completion: nil)
    }

    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    

    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
        self.nameLabel.text = "No place selected"
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //      1. get the photo
        if let photo = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            
            //      2. display in UImageView
            self.pickedImage = photo
            self.cameraBTN.setImage(self.pickedImage, for: .normal)
            
            
            //store image to core data
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddPostViewController {
    
    
    func presentImagePicker(){
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .cappedTo(size: 500.0)
        config.usesFrontCamera = true
        config.showsFilters = true
        
        config.shouldSaveNewPicturesToAlbum = true
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        self.picker = YPImagePicker(configuration: config)
        present(self.picker, animated: true, completion: nil)
        self.picker.didFinishPicking { [unowned self] items, _ in
            if let photo = items.singlePhoto {
                self.cameraBTN.setImage(photo.image, for: .normal)
            }
            self.picker.dismiss(animated: true, completion: nil)
        }
    }
}
