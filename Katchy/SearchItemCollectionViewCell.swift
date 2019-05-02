//
//  SearchItemCollectionViewCell.swift
//  Katchy
//
//  Created by Katrina Liu on 4/29/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var search: UIImageView!
    
    var photo: Photo! {
        didSet {
            
             search.image = photo.image
        }
    }
}
