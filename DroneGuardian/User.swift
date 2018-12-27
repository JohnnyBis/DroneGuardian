//
//  User.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/25/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import Foundation
import FirebaseAuth

let uid = Auth.auth().currentUser?.uid

class User{
    
    public private(set) var username: String
    public private(set) var imageUrl: String?
    public private(set) var balance: Int
    public private(set) var pilot: Bool
    public private(set) var userID: String
    public private(set) var email: String
    public private(set) var phoneNumber: String
    public private(set) var address: String
    public private(set) var company: String
    public private(set) var insurance: String
    public private(set) var coverage: String
    public private(set) var milesAvailable: String
    public private(set) var weekdays: Bool
    public private(set) var weekends: Bool
    public private(set) var patentID: String
    public private(set) var drones: Array<String>
    public private(set) var status: String
    public private(set) var licenses: Array<String>

    
    
    init(username: String, imageUrl: String?, balance: Int, pilot: Bool, id: String, address: String?, email: String, company: String, insurance: String, coverage: String, phoneNumber: String, milesAvailable: String, weekdays: Bool, weekends: Bool, patentID: String, drones: Array<String>, status: String, licenses: Array<String>) {
        self.username = username
        self.imageUrl = imageUrl
        self.balance = balance
        self.pilot = pilot
        self.userID = id
        self.address = address!
        self.company = company
        self.email = email
        self.phoneNumber = phoneNumber
        self.insurance = insurance
        self.coverage = coverage
        self.milesAvailable = milesAvailable
        self.weekdays = weekdays
        self.weekends = weekends
        self.patentID = patentID
        self.drones = drones
        self.status = status
        self.licenses = licenses
    }
    
    init(licenses: Array<String>){
        self.licenses = licenses
    }
    
    static func fetchUserData(uid: String, completionBlock: @escaping (_ user: User) -> Void){
        DataService.ds.REF_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                let username = (data!["Full Name"])! as! String
                let url = (data!["Profile Url"])! as! String
                let pilot = (data!["Pilot"])! as! Bool
                let id = (data!["Id"]) as! String
                let address = (data!["Address"]) as! String
                let phoneNumber = (data!["Phone"]) as! String
                let insurance = (data!["Insurance"]) as! String
                let coverage = (data!["Coverage"]) as! String
                let company = (data!["Company"]) as! String
                let email = (data!["Email"]) as! String
                let milesAvaible = (data!["Miles available"]) as! String
                let weekdays = (data!["Weekdays"]) as! Bool
                let weekends = (data!["Weekends"]) as! Bool
                let patentID = (data!["Patent ID"]) as! String
                let drones = (data!["Drones"]) as! Array<String>
                let status = (data!["Status"]) as! String
                let licenses = (data!["License"]) as! Array<String>
                
                let user = User(username: username, imageUrl: url, balance: 0, pilot: pilot, id: id, address: address, email: email, company: company, insurance: insurance, coverage: coverage, phoneNumber: phoneNumber, milesAvailable: milesAvaible, weekdays: weekdays, weekends: weekends, patentID: patentID, drones: drones, status: status, licenses: licenses)
                
                
                completionBlock(user)
            }else{
                print("User document error.")
            }
        }
    }
    
    
    static func fetchUserLicenses(uid: String, completionBlock: @escaping (_ licenses: Array<String>) -> Void){
        DataService.ds.REF_USERS.document(uid).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                let licenses = (data!["License"]) as! Array<String>
                completionBlock(licenses)
            }else{
                print("User document error.")
            }
        }
        
    }
    
}
