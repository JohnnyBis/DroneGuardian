//
//  LoginViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/24/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(red:0.17, green:0.73, blue:0.70, alpha:1.0).cgColor
        emailField.delegate = self
        passwordField.delegate = self
        loginButton.layer.shadowColor = UIColor(red:0.11, green:0.47, blue:0.45, alpha:1.0).cgColor
        loginButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 0.5
        errorMessage.isHidden = true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil{
                print(error!)
                self.errorMessage.text = "Incorrect username or password."
                self.viewOne.layer.backgroundColor = UIColor.red.cgColor
                self.viewTwo.layer.backgroundColor = UIColor.red.cgColor
                self.errorMessage.isHidden = false
                
            }else{
                self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
                self.emailField.text = ""
                self.passwordField.text = ""
                print("Succesfully signed in")
            }
        })

    }
    
    
}
