//
//  Item.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import Foundation
import Firebase

class Items {
    var itemArray: [Item] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("items").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.itemArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
                // You'll have to be sure you've created an initializer in the singular class (Spot, below) that acepts a dictionary.
                let item = Item(dictionary: document.data())
                item.documentID = document.documentID
                self.itemArray.append(item)
            }
            completed()
        }
    }
}
