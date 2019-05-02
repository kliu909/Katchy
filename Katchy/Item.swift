//
//  ItemDetail.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import Foundation
import Firebase

class Item {
    var itemName: String
    var price: String
    var description: String
    var sellerName: String
    var contactInfo: String
    var documentID: String
    var likes: Int
    var dictionary: [String: Any] {
        return ["itemName": itemName, "price": price, "description":
            description, "sellerName": sellerName, "contactInfo": contactInfo, "likes": likes]
    }
    
    init(itemName: String, price: String, description: String, sellerName: String, contactInfo: String, likes:Int, documentID: String)
    {
        self.itemName = itemName
        self.price = price
        self.description = description
        self.sellerName = sellerName
        self.contactInfo = contactInfo
        self.likes = likes
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(itemName: "", price: "", description: "", sellerName: "", contactInfo: "", likes: 0, documentID: "")
    }
    
    
    convenience init(dictionary: [String: Any]) {
        let itemName = dictionary["itemName"] as! String? ?? ""
        let price = dictionary["price"] as! String? ?? ""
        let description = dictionary["description"] as! String? ?? ""
        let sellerName = dictionary["sellerName"] as! String? ?? ""
        let contactInfo = dictionary["contactInfo"] as! String? ?? ""
       let likes = dictionary["likes"] as! Int? ?? 0
        self.init(itemName: itemName, price: price, description: description, sellerName: sellerName, contactInfo: contactInfo, likes: likes, documentID: "" )
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
            
        }
        
       
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("items").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("items").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
}
