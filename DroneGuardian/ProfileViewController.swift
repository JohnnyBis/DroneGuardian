//
//  ProfileViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/24/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
var selectedCells: [String] = []

class ProfileViewController: UIViewController, UITextFieldDelegate{
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var insuranceNumber: UITextField!
    @IBOutlet weak var coverage: UITextField!
    @IBOutlet weak var chosenDrones: UILabel!
    @IBOutlet weak var idNumber: UITextField!
    @IBOutlet weak var milesAvailability: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weekdaysButton: UIButton!
    @IBOutlet weak var weekendsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        fetchUserData()
        fullName.delegate = self
        email.delegate = self
        address.delegate = self
        phoneNumber.delegate = self
        companyName.delegate = self
        insuranceNumber.delegate = self
        coverage.delegate = self
        chosenDrones.text = "My drone model"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserData()
        DataService.ds.REF_USERS.document(uid!).setData(["Drones": selectedCells], merge: true)
        fetchChosenDrones()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserData(){
        User.fetchUserData(uid: uid!) { (user) in
            self.username.text = user.username
            self.fullName.text = user.username
            self.email.text = user.email
            self.address.text = user.address
            self.phoneNumber.text = user.phoneNumber
            self.companyName.text = user.company
            self.insuranceNumber.text = user.insurance
            self.coverage.text = user.coverage
            self.milesAvailability.text = user.milesAvailable
            self.weekendsButton.isSelected = user.weekends
            self.weekdaysButton.isSelected = user.weekdays
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DataService.ds.REF_USERS.document(uid!).updateData(["Full Name":fullName.text!, "Email":email.text!, "Address":address.text!, "Phone":phoneNumber.text!, "Company":companyName.text!, "Insurance":insuranceNumber.text!, "Coverage":coverage.text!, "Miles available": milesAvailability.text!])
    }
    
    func fetchChosenDrones(){
        DataService.ds.REF_USERS.document(uid!).getDocument { (document, error) in
            if error != nil{
                print(error!)
            }else{
                let user = document?.data()
                let drones = user!["Drones"]
                print(drones!)
                self.chosenDrones.text = "\(drones!))"
//                self.chosenDrones.text = self.chosenDrones.text?.replacingOccurrences(of: "[", with: "")
//                self.chosenDrones.text = self.chosenDrones.text?.replacingOccurrences(of: "]", with: "")
            }
        }
    }

    @IBAction func weekdaysButtonPressed(_ sender: UIButton) {
        if weekdaysButton.isSelected == false{
            weekdaysButton.isSelected = true
            DataService.ds.REF_USERS.document(uid!).setData(["Weekdays": true], merge: true)
            
        }else{
            weekdaysButton.isSelected = false
            DataService.ds.REF_USERS.document(uid!).setData(["Weekdays": false], merge: true)

        }
        
        
    }
    
    @IBAction func weekendsButtonPressed(_ sender: UIButton) {
        if weekendsButton.isSelected == false{
            weekendsButton.isSelected = true
            DataService.ds.REF_USERS.document(uid!).setData(["Weekends": true], merge: true)
        }else{
            weekendsButton.isSelected = false
            DataService.ds.REF_USERS.document(uid!).setData(["Weekends": false], merge: true)

        }
    }
}
