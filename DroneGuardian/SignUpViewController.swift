//
//  SignUpViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/25/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

var pilot: Bool = false

class SignUpViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userData: [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor(red:0.17, green:0.73, blue:0.70, alpha:1.0).cgColor
        
        signUpButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        fullNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        creatDBUser()
    }
    
    func creatDBUser(){
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil{
                print(error!)
                
            }else{
                self.userData = ["Full Name": self.fullNameField.text!, "Balance": 0, "Pilot": pilot, "Address": "", "Phone": "", "Insurance": "", "Coverage": "", "Company": "", "Email": self.emailField.text!, "Id": uid!, "Number": "", "Miles available": "", "Weekdays": false, "Weekends": false, "Patent ID": "", "Drones": [], "License": [], "Status": "Online", "Profile Url": ""]
                DataService.ds.createFirebaseDBUsers(uid: (user?.user.uid)!, userData: self.userData)
                print("Successful registration")
                self.performSegue(withIdentifier: "goToMapFromSignUp", sender: self)
                
            }
        })
        
    }

}
