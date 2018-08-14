//
//  ProfileTableViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/7/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UITextFieldDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullName.delegate = self
        email.delegate = self
        address.delegate = self
        phoneNumber.delegate = self
        companyName.delegate = self
        insuranceNumber.delegate = self
        coverage.delegate = self
        tableView.isScrollEnabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func fetchData(){
        User.fetchUserData(uid: uid!) { (user) in
            self.fullName.text = user.username
            self.email.text = user.email
            self.address.text = user.address
            self.phoneNumber.text = user.phoneNumber
            self.companyName.text = user.company
            self.insuranceNumber.text = user.insurance
            self.coverage.text = user.coverage
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }



}
