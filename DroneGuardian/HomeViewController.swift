//
//  HomeViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/24/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseAuth
import GradientLoadingBar

class HomeViewController: UIViewController{
    
    var navigationLoadingBar: BottomGradientLoadingBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = navigationController?.navigationBar {
            navigationLoadingBar = BottomGradientLoadingBar(onView: navigationBar)
        }
        
        guard let navigationLoadingBar = navigationLoadingBar else { return }
        let logo = UIImage(named: "droneguardy_horizontal_logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       GradientLoadingBar.shared.hide()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser?.uid != nil {
//            self.performSegue(withIdentifier: "goToMapFromHome", sender: self)
//            
//        }
//    }
    
    @IBAction func dronePilotButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInformationFromHome", sender: self)

        pilot = true
        navigationLoadingBar?.toggle()

    }
    
    @IBAction func clientButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInformationFromHome", sender: self)
        navigationLoadingBar?.toggle()


    }
    
}

class BottomGradientLoadingBar: GradientLoadingBar {
    override func setupConstraints() {
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: CGFloat(height))
            ])
    }
}
