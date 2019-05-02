//
//  SearchListViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var items: Items!
    var item: Item!
    var photos: Photos!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        items = Items()
        item = Item()
        photos = Photos()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items.loadData {
            self.tableView.reloadData()
            print("!!!item loaded in view will appear")
        }
//        photos.loadData(item: item) {
//            self.coll.reloadData()
//        }
    }
    
    
     func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDetail" {
            let destination = segue.destination as! SearchTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.item = items.itemArray[selectedIndexPath.row]
            
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }

    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
        }
    }
    
   
}

extension SearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items.itemArray[indexPath.row].itemName
        //print(items.itemArray[indexPath.row].itemName)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let sureAlert = UIAlertController(title: "Delete Item", message: "Are you the seller?", preferredStyle: UIAlertController.Style.alert)
            
            sureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle yes logic here")
                self.items.itemArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            sureAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(sureAlert, animated: true, completion: nil)
            
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let itemDetail: SellTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SellTableViewController") as! SellTableViewController
//        itemDetail.itemNameField.text = items.itemArray[indexPath.row].itemName
//        itemDetail.priceField.text = items.itemArray[indexPath.row].price
//        itemDetail.descriptionTextView.text = items.itemArray[indexPath.row].description
//        itemDetail.sellerNameField.text = items.itemArray[indexPath.row].sellerName
//        itemDetail.contactInfoField.text = items.itemArray[indexPath.row].contactInfo
////        itemDetail.collectionView = photos.photoArray
//        itemDetail.collectionView.reloadData()
//        self.navigationController?.pushViewController(itemDetail, animated: true)
//    }
//    

    
}
