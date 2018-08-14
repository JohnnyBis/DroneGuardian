//
//  TermsAndConditionsViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/7/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://app.termly.io/document/terms-of-use-for-website/b7027844-4f99-4153-8eec-84a96362bdab")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
