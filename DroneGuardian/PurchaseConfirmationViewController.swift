//
//  PurchaseConfirmationViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 10/16/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class PurchaseConfirmationViewController: UIViewController {

    @IBOutlet weak var successMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successMessage.text = "You have successfully purchased \(selectedItemName). Thank you for shopping with us. You will soon receive a confirmation email."

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
