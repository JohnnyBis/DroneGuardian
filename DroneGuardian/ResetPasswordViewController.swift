//
//  ResetPasswordViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/28/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if emailField.text != ""{
            Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
                if error != nil{
                    print(error!)
                }
            }
        }
        
    }
    
}
