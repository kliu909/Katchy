//
//  SellViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit
import Contacts

class SellTableViewController: UITableViewController {
    
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sellerNameField: UITextField!
    @IBOutlet weak var contactInfoField: UITextField!

     @IBOutlet weak var collectionView: UICollectionView!
    
    var item: Item!
    var photos: Photos!
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item == nil {
            item = Item()
            photos = Photos()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        imagePicker.delegate = self
    }



    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateDataFromInterface() {
        item.itemName = itemNameField.text!
        item.price =  priceField.text!
        item.description = descriptionTextView.text!
        item.sellerName = sellerNameField.text!
        item.contactInfo = contactInfoField.text!
        
    }
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.accessCamera()

        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {_ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
       
            cameraOrLibraryAlert()
        }
        
 
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        self.updateDataFromInterface()
        item.saveData { success in
            
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller becausee data wasn't saved.")
            }
            
        }
        
    }
    
        @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
            leaveViewController()
        }
    
}

extension SellTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ItemPhotosCollectionViewCell
        cell.photo = photos.photoArray[indexPath.row]
        return cell
    }
    
    
}

extension SellTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        dismiss(animated: true) {
            
            photo.saveData(item: self.item) { (success) in
                self.photos.photoArray.append(photo)
                self.collectionView.reloadData()
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