//
//  WelcomeViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/16/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeImage: UIImageView!
    @IBOutlet weak var pilotInformation: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pilot != true{
            welcomeImage.image = UIImage(named: "client image")
            pilotInformation.isHidden = true
        }
        loginButton.layer.cornerRadius = 5
        loginButton.layer.shadowColor = UIColor.gray.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOpacity = 0.5
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
