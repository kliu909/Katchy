//
//  SearchListViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchListViewController: SearchViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var items: Items!
  //  var itemName = ["Black Shorts", "Ripped Blue Jeans", "Pink T- Shirt"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        items = Items()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        items.loadData {
            self.tableView.reloadData()
        }
    }
    
    
    override func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDetail" {
            let destination = segue.destination as! SellTableViewController
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
    
}
