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
    
    @IBOutlet var imageCollection: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableImageGestureRecognizer()

        
    }

    func enableImageGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageCollection[0].isUserInteractionEnabled = true
        imageCollection[0].addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageCollection[1].isUserInteractionEnabled = true
        imageCollection[1].addGestureRecognizer(tapGestureRecognizerTwo)
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage.tag)
        if tappedImage.tag == 1{
            pilot = true
            
        }else{
            pilot = false
        }
        self.performSegue(withIdentifier: "goToInformationFromHome", sender: self)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser?.uid != nil {
//            self.performSegue(withIdentifier: "goToMapFromHome", sender: self)
//            
//        }
//    }
    
}
