//
//  PrivacyViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/7/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://app.termly.io/document/privacy-policy/585e4d11-b91f-4063-95d1-f9311269d2ed")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
