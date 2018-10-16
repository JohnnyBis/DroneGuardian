//
//  ItemShopViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 9/28/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import Firebase

class ItemShopViewController: UIViewController {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        itemName.text = 
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    let token = "sandbox_j9h9fm4j_8dbn6ryjv42y7dw5"

        
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
        let paymentURL = URL(string:"https://droneguardypayments.herokuapp.com/pay.php")!
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
            
            print("Successfully charged $\(amount)")
            }.resume()
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        showDropIn(clientTokenOrTokenizationKey: token)

    }
    
}
