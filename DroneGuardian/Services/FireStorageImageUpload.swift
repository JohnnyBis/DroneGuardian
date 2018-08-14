//
//  FireStorageImageUpload.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/26/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class FireStorageImageUpload: NSObject{
    
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void){
        
        //References
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imagePostFolder = "itemImages"
        
        //Path to upload image
        let imageName = "\(Date().timeIntervalSinceNow).jpg"
        let imageReference = storageReference.child(imagePostFolder).child(imageName)
        
        if Auth.auth().currentUser != nil{
            //Convert UIImage to JPEG
            if let convertedImage = UIImageJPEGRepresentation(image, 0.1){
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                let uploadTask = imageReference.putData(convertedImage)
                imageReference.downloadURL { (url, error) in
                    if error != nil{
                        print(error!)
                    }else{
                        completionBlock(url, nil)
                    }
                }
                //                let uploadTask = imageReference.putData(convertedImage, metadata: metadata, completion: { (metadata, error) in
                //                    if let metadata = metadata{
                //                        completionBlock(metadata.downloadURL(), nil)
                //                    }else{
                //                        completionBlock(nil, error?.localizedDescription)
                //                    }
                //                })
                
                uploadTask.observe(.progress, handler: { (snapshot) in
                    guard let uploadProgress = snapshot.progress else{
                        return
                    }
                    
                    let uploadPercentage = (Double(uploadProgress.completedUnitCount) / Double(uploadProgress.totalUnitCount)) * 100
                    progressBlock(uploadPercentage)
                    
                })
                
            }else{
                completionBlock(nil, "Not able to convert UIImage to JPEG.")
            }
        }else{
            print("Upload image error: user could not be authenticated.")
        }
        
    }
}
