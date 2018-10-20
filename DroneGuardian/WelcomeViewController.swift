//
//  WelcomeViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/16/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeImage: UIImageView!
    @IBOutlet weak var pilotInformation: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pilot != true{
            welcomeImage.image = UIImage(named: "client image")
            pilotInformation.isHidden = true
            welcomeLabel.isHidden = true
        }
        buttonDesign(button: loginButton)
        buttonDesign(button: facebookLogin)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonDesign(button: UIButton){
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {

        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                if let currentUser = Auth.auth().currentUser {
                    let userData = ["Full Name": currentUser.displayName!, "Balance": 0, "Pilot": pilot, "Address": "", "Phone": "", "Insurance": "", "Coverage": "", "Company": "", "Email": currentUser.email!, "Id": uid!, "Number": "", "Miles available": "", "Weekdays": false, "Weekends": false, "Patent ID": "", "Drones": [], "License": [], "Status": "Online", "Profile Url": ""] as [String : Any]
                    DataService.ds.createFirebaseDBUsers(uid: (user?.user.uid)!, userData: userData)
                }
                
                // Present the main view
                self.performSegue(withIdentifier: "goFromWelcomeToHome", sender: self)
                
            })
        }
    }
    
}
