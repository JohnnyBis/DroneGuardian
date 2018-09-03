//
//  DroneLivestreamViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/3/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import YouTubePlayer
import Firebase

class DroneLivestreamViewController: UIViewController {
    
    @IBOutlet weak var streamView: UIWebView!
    @IBOutlet weak var standByStream: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standByStream.layer.cornerRadius = 5
        changeListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func watchDroneStream(youtubeUrl: String){
        if let streamId = URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value{
            let string = "https://www.youtube.com/embed/\(streamId)"
            if let url = URL(string: string){
                streamView.loadRequest(URLRequest(url: url))
            }

            
        }
    }
    
    func changeListener(){
        DataService.ds.REF_MISSIONS.whereField("Pilot", isEqualTo: selectedPilotID).getDocuments { (doc, error) in
            if error != nil{
                print(error!)
                return
            }
            for document in (doc?.documents)!{
                let documentId = document.documentID
                DataService.ds.REF_MISSIONS.document(documentId).addSnapshotListener({ (doc, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    
                    let url = doc?.data()!["Url"] as! String
                    if url != ""{
                        self.watchDroneStream(youtubeUrl: url as! String)
                        self.standByStream.isHidden = true
                    }
                })
            }
        }

    }

}
