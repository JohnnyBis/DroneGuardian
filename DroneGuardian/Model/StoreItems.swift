//
//  StoreItems.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 10/12/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import Foundation
import FirebaseAuth

class StoreItems{
    
    private var name: String?
    private var description: String?
    private var price: String?
    public private(set) var topItemRef: String?
    public private(set) var leftItemRef: String?
    public private(set) var rightItemRef: String?
    
    init(name: String, description: String?, price: String?) {
        self.name = name
        self.description = description
        self.price = price
    }
    
    init(topItemRef: String, leftItemRef: String?, rightItemRef: String?) {
        self.topItemRef = topItemRef
        self.leftItemRef = leftItemRef
        self.rightItemRef = rightItemRef
    }
    
    static func fetchRow(categoryName: String, completionBlock: @escaping (_ StoreItems: StoreItems) -> Void){
        DataService.ds.REF_STORE.document(categoryName).getDocument { (items, error) in
            var topItemRef: String
            var rightItemRef: String
            var leftItemRef: String
            if let items = items, items.exists{
                let data = items.data()
                switch categoryName{
                case "Category 1":
                    topItemRef = data!["Top Item"] as! String
                    rightItemRef = data!["Right Item"] as! String
                    leftItemRef = data!["Left Item"] as! String
                    let itemRefs = StoreItems(topItemRef: topItemRef, leftItemRef: leftItemRef, rightItemRef: rightItemRef)
                    completionBlock(itemRefs)
                    
                case "Category 2":
                    topItemRef = data!["Top Item"] as! String
                    let itemRefs = StoreItems(topItemRef: topItemRef, leftItemRef: nil, rightItemRef: nil)
                    completionBlock(itemRefs)
                    
                case "Category 3":
                    topItemRef = data!["Top Item"] as! String
                    rightItemRef = data!["Right Item"] as! String
                    let itemRefs = StoreItems(topItemRef: topItemRef, leftItemRef: nil, rightItemRef: rightItemRef)
                    completionBlock(itemRefs)
                    
                default:
                    print("Not a valid category")
                }
            }
        }
    }
    
    
}
