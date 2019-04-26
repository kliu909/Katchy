//
//  SearchViewController.swift
//  Katchy
//
//  Created by Katrina Liu on 4/22/19.
//  Copyright © 2019 Katrina Liu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {


    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    

    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
   
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchList", sender: nil)
    }
    
}

//
//extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return typeArray.count
//    }
//
//
//}
