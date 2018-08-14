//
//  HomeViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/24/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dronePilotButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInformationFromHome", sender: self)
        pilot = true
    }
    
    @IBAction func clientButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInformationFromHome", sender: self)
    }
}
