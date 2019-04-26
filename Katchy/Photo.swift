//
//  Photo.swift
//  Katchy
//
//  Created by Katrina Liu on 4/24/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import Foundation
import Firebase

class Photo {
    var image: UIImage
    var description: String
    var postedBy: String
    var date: Date
    var documentUUID: String
    
    var dictionary: [String:Any] {
        return ["description": description, "postedBy":postedBy, "date": date]
    }
    
    init(image: UIImage, description: String, postedBy: String, date: Date, documentUUID: String) {
        self.image = image
        self.description = description
        self.postedBy = postedBy
        self.date = date
        self.documentUUID = documentUUID
    }
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(image: UIImage(), description: "", postedBy: postedBy, date: Date(), documentUUID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let description = dictionary["description"] as! String? ?? ""
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let date = dictionary["date"] as! Date? ?? Date()
        self.init(image: UIImage(), description: description, postedBy: postedBy, date: date, documentUUID: "")
    }
    
    func saveData(item: Item, completed: @escaping (Bool)->()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        // covert photo.image to a Date type so it can be saved by Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("error")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString //generate unique ID to use for the photot image's name
        //create ref to upload storage to spot.documentID's folder (bucket), with the name we create
        let storageRef = storage.reference().child(item.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) {metadata, error in
            guard error == nil else {
                print("😡 ERROR during .putData storage upload for reference \(storageRef). Error: \(error!.localizedDescription)")
                return
            }
            print("😎 Upload worked! Metadata is \(metadata)")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            // create dictionary representing data we want to save
            let dataToSave = self.dictionary
            // this will either create new doc at documentUUID or update existing doc
            
            let ref = db.collection("items").document(item.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("$$$4 error ")
                    completed(false)
                } else {
                    print("updated with \(ref.documentID)")
                    completed(true)
                }
            }
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("Error: upload task for file \(self.documentUUID) failed, in spot \(item.documentID)")
            }
            return completed(false)
        }
        
    }
}
