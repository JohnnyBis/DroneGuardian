//
//  DataService.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/25/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Firestore.firestore()

class DataService{
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_MISSIONS = DB_BASE.collection("Missions")
    private var _REF_USERS = DB_BASE.collection("Users")
    
    var REF_BASE: Firestore{
        return _REF_BASE
    }
    
    var REF_MISSIONS: CollectionReference{
        return _REF_MISSIONS
    }
    
    var REF_USERS: CollectionReference{
        return _REF_USERS
    }
    
    
    func createFirebaseDBUsers(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.document(uid).setData(userData) { (error) in
            if error != nil{
                print("Error: \(error!)")
            }else{
                print("Successfully registered user to Firestore database.")
            }
        }
    }
    
    
    func createFirebaseDBMission(userData: Dictionary<String, Any>){
        REF_MISSIONS.addDocument(data: userData) { (error) in
            if error != nil{
                print(error!)
            }else{
                print("Successfully registered mission to Firestore database")
            }
        }
        
    }
    
    func addDataFirebaseDBPosts(userData: Dictionary<String, Any>, uid: String){
        REF_USERS.document(uid).setData(userData, merge: true) { (error) in
            if error != nil{
                print(error!)
            }
            return
        }
    }
    
    
}
