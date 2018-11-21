//
//  Missions.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 8/5/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import Foundation

class Missions{
    
    public private(set) var client: String
    public private(set) var price: Int
    public private(set) var livestreamUrl: String
    public private(set) var documentId: String
    
    
    init(client: String?, price: Int?, livestreamUrl: String?, docID: String) {
        self.client = client!
        self.price = price!
        self.livestreamUrl = livestreamUrl!
        self.documentId = docID
    }
    
    static func fetchUserMissions(uid: String, completionBlock: @escaping (_ mission: Missions) -> Void){
        DataService.ds.REF_MISSIONS.whereField("Pilot", isEqualTo: uid).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error!)
            }else{
                snapshot?.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let document = diff.document.data()
                        let price = document["Price"] as! Int
                        let client = document["Client"] as! String
                        let livestreamUrl = document["Url"] as! String
                        let docID = diff.document.documentID
                        let mission = Missions(client: client, price: price, livestreamUrl: livestreamUrl, docID: docID)
                        completionBlock(mission)
                    }
                }
            }
        }
    }
    
    //        DataService.ds.REF_MISSIONS.whereField("Pilot", isEqualTo: uid).getDocuments { (document, error) in
    //            if error != nil{
    //                print(error!)
    //                return
    //            }
    //            for document in document!.documents {
    //                let price = document["Price"] as! Int
    //                let client = document["Client"] as! String
    //                let livestreamUrl = document["Url"] as! String
    //                let docID = document.documentID
    //                let mission = Missions(client: client, price: price, livestreamUrl: livestreamUrl, docID: docID)
    //                completionBlock(mission)
    //            }
    //        }



    
}
