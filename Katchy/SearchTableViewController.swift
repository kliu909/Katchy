//
//  SearchTableViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var sellItemNameField: UITextField!
    @IBOutlet weak var searchPriceField: UITextField!
    @IBOutlet weak var sellDescriptionTextView: UITextView!
    @IBOutlet weak var sellSellerNameField: UITextField!
    @IBOutlet weak var sellContactInfoField: UITextField!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var photoButton: UIButton!
    //    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    @IBOutlet weak var likeTextField: UITextField!
    
    var item: Item!
    var items: Items!
    
    var photos: Photos!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoButton.layer.cornerRadius = 9
        
        updateDataFromInterface()
        
        imagePicker.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        print(item.itemName)
        photos = Photos()
//       photos.loadData(item: item)
//       {
//        print("^^^^ reload pic")
//            self.searchCollectionView.reloadData()
//            }
        }
    
//
    override func viewWillAppear(_ animated: Bool) {

        photos.loadData(item: item) {
            self.searchCollectionView.reloadData()
            print("###photo loaded")
            print(self.photos.photoArray.count)
        }
    }
  
    
     func updateDataFromInterface() {
        sellItemNameField.text = item.itemName
        
        searchPriceField.text = item.price
        sellDescriptionTextView.text = item.description
        sellSellerNameField.text = item.sellerName
        sellContactInfoField.text = item.contactInfo
        likeTextField.text = String(item.likes)
      //  searchCollectionView.cellForItem(at: photos.photoArray.startIndex)
    }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.accessCamera()
            
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        let sureAlert = UIAlertController(title: "Open Images", message: "Are you the seller?", preferredStyle: UIAlertController.Style.alert)
        
        sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle yes logic here")
            self.cameraOrLibraryAlert()
        }))
        
        sureAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(sureAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        self.view.backgroundColor = UIColor.green
       item.likes += 1
        print(item.likes)
        item.saveData { success in 
            
        }
        
    }
    
   
}

extension SearchTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let photo = Photo()
        
        print("*****\(photos.photoArray.count)")
        return photos.photoArray.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as!
            SearchItemCollectionViewCell
        cell.photo = photos.photoArray[indexPath.row]
        
        return cell
    }
   

}
extension SearchTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        print("printing photo")
        dismiss(animated: true) {
            print("****dismissed")
            
            photo.saveData(item: self.item) { success in
                print("**&&***Save photo success")
                self.photos.photoArray.append(photo)
                self.searchCollectionView.reloadData()
                print(self.photos.photoArray.count)
            }
            
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device")
        }
    }
}
