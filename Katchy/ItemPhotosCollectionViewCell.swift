//
//  PhotoCollectionViewCell.swift
//  Katchy
//
//  Created by Katrina Liu on 4/24/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class ItemPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var searchImageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            photoImageView.image = photo.image
            searchImageView.image = photo.image
        }
    }
    
}
