//
//  SearchTableViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchTableViewController: SellTableViewController {

    @IBOutlet weak var sellItemNameField: UITextField!
    @IBOutlet weak var searchPriceField: UITextField!
    @IBOutlet weak var sellDescriptionTextView: UITextView!
    @IBOutlet weak var sellSellerNameField: UITextField!
    @IBOutlet weak var sellContactInfoField: UITextField!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
   // @IBOutlet weak var searchImage: UIImageView!
    
    var photo: Photos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromInterface()
        
     //   collectionView.d
        
        }
    
  
    
    override func updateDataFromInterface() {
        sellItemNameField.text = item.itemName
        searchPriceField.text = item.price
        sellDescriptionTextView.text = item.description
        sellSellerNameField.text = item.sellerName
        sellContactInfoField.text = item.contactInfo
        
    }
}


