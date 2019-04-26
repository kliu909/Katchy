//
//  Photos.swift
//  Katchy
//
//  Created by Katrina Liu on 4/24/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import Foundation
import Firebase


class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
}
