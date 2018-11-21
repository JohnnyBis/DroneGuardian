//
//  AddLicensePictureViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 11/17/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseStorage

var newImage: UIImage!

class AddLicensePictureViewController: UIViewController {
    
    
    @IBOutlet weak var licenseImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(newImage)
        licenseImage.image = newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insuranceTypeButtonPressed(_ sender: UIButton) {
        uploadImage(newImage) { (url, error) in
            if error != nil{
                print(error!)
                return
            }
            
            if sender.tag == 1{
                DataService.ds.REF_USERS.document(uid!).updateData(["107": url!])
                
            }else if sender.tag == 2{
                DataService.ds.REF_USERS.document(uid!).updateData(["333": url!])

            }else{
                DataService.ds.REF_USERS.document(uid!).updateData(["TP": url!])
                
            }
        }
    }
    
    func uploadImage(_ image: UIImage, completionBlock: @escaping (_ url: String?, _ errorMessage: String?) -> Void) {
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        let storageRef = Storage.storage().reference()
        var specificRef: StorageReference
        
        specificRef = storageRef.child("Licenses").child(UUID().uuidString)
    
        
        specificRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                completionBlock(nil, "Couldnt upload due to \(String(describing: error))")
                
            } else {
                specificRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    completionBlock(downloadURL.absoluteString, nil)
                })
            }
        }
    }

    
}
