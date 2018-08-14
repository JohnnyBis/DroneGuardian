//
//  StreamSetupViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/3/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import Firebase

class StreamSetupViewController: UIViewController {

    let token = "sandbox_j9h9fm4j_8dbn6ryjv42y7dw5"

    @IBOutlet weak var payNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: token, request: request)
        { [unowned self] (controller, result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if (result?.isCancelled == true) {
                print("Transaction Cancelled")
                
            } else if let nonce = result?.paymentMethod?.nonce{
                self.sendRequestPaymentToServer(nonce: nonce, amount: "50")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
        
    }
    
    func sendRequestPaymentToServer(nonce: String, amount: String) {
        let paymentURL = URL(string:"http://192.168.64.2/Donate/pay.php")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) -> Void in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = result?["success"] as? Bool, success == true else {
                print("Transaction failed. Please try again.")
                return
            }
            self.payNowButton.isSelected = true
            
//            DataService.ds.REF_USERS.document(uid!).getDocument(completion: { (user, error) in
//                let balance = user!["Balance"] as! Int
//                DataService.ds.REF_USERS.document(uid!).updateData(["Balance": balance+50])
//            })
            print("Successfully charged $\(amount)")
            }.resume()
    }
    
    @IBAction func payNowButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToStreamFromSetup", sender: self)
        User.fetchUserData(uid: uid!, completionBlock: { (user) in
            let fullName = user.username
            DataService.ds.REF_MISSIONS.document().setData(["Client": fullName, "Price": 50, "Url": "", "Pilot": selectedPilotID])
        })
//        showDropIn(clientTokenOrTokenizationKey: token)
        
    }
    
}
