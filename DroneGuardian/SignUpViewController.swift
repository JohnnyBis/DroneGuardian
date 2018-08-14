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
import M13Checkbox

var pilot: Bool = false

class SignUpViewController: UIViewController{

    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var privacyCheckBox: M13Checkbox!
    
    var userData: [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor(red:0.17, green:0.73, blue:0.70, alpha:1.0).cgColor
        let check = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        let privacyCheck = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))

        checkBox.addSubview(check)
        privacyCheckBox.addSubview(privacyCheck)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        userData = ["Full Name":fullNameField.text!, "Balance": 0, "Pilot": pilot, "Address": "", "Phone": "", "Insurance": "", "Coverage": "", "Company": "", "Email": emailField.text!]
        creatDBUser(userData: userData)
    }
    
    func creatDBUser(userData: Dictionary<String, Any>){
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil{
                print(error!)
                
            }else{
                DataService.ds.createFirebaseDBUsers(uid: (user?.user.uid)!, userData: userData)
                DataService.ds.addDataFirebaseDBPosts(userData: ["Id": user?.user.uid], uid: (user?.user.uid)!)
                print("Successful registration")
                self.performSegue(withIdentifier: "goToMapFromSignUp", sender: self)
                
            }
        })
        
    }

}
