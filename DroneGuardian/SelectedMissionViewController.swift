//
//  SelectedMissionViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/5/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class SelectedMissionViewController: UIViewController {

    @IBOutlet weak var missionDetails: UILabel!
    @IBOutlet weak var livestreamUrlTextField: UITextField!
    @IBOutlet weak var livestreamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionDetails.text = "- Open the DJI GO App and click the 3 dot button on right top corner of your screen. \n -  A New window will appear. Click Choose Live Broadcast \n - Select Youtube and follow the provided instructions. \n \n Once completed copy and paste the Youtube livestream Url below."

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func postLivestreamButtonPressed(_ sender: UIButton) {
        DataService.ds.REF_MISSIONS.document(documentId).updateData(["Url":livestreamUrlTextField.text!])
        performSegue(withIdentifier: "goToMessageFromSetup", sender: self)
    }
    
}
