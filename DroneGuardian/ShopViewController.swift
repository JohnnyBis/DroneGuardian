//
//  ShopViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 9/28/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView
import FirebaseAuth
import Firebase

class ShopViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var categoryOneLabels: [UILabel]!
    @IBOutlet var categoryTwoLabels: [UILabel]!
    @IBOutlet var categoryThreeLabels: [UILabel]!
    @IBOutlet var categoryOneImages: [UIButton]!
    @IBOutlet var categoryTwoImages: [UIButton]!
    @IBOutlet var categoryThreeImages: [UIButton]!
    
    var imageTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = UIColor.clear
        scrollView.delegate = self
//        addSkeletonToImage(imageCollection: categoryOneImages)
//        addSkeletonToLabel(labelCollection: categoryOneLabels)
        self.navigationItem.title = "Your Title"

        fetchFirstCategory()
        fetchSecondCategory()
        fetchThirdCategory()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSkeletonToImage(imageCollection: [UIImageView]){
        for image in imageCollection{
            image.showAnimatedSkeleton()
        }
    }
    
    func addSkeletonToLabel(labelCollection: [UILabel]){
        for label in labelCollection{
            label.showAnimatedSkeleton()
        }
    }
    
    func fetchFirstCategory(){
        fetchItemReferences(category: "Category 1") { (itemRefs) in
            self.fetchDataFromRef(reference: itemRefs[0], itemLabel: self.categoryOneLabels[0], itemImage: nil)
            self.fetchDataFromRef(reference: itemRefs[1], itemLabel: self.categoryOneLabels[1], itemImage: nil)
            self.fetchDataFromRef(reference: itemRefs[2], itemLabel: self.categoryOneLabels[2], itemImage: nil)
        }
    }

    func fetchSecondCategory(){
        fetchItemReferences(category: "Category 2") { (itemRefs) in
            self.fetchDataFromRef(reference: itemRefs[0], itemLabel: self.categoryTwoLabels[0], itemImage: nil)
        }
    }
    
    func fetchThirdCategory(){
        fetchItemReferences(category: "Category 3") { (itemRefs) in
            print(itemRefs)
            self.fetchDataFromRef(reference: itemRefs[0], itemLabel: self.categoryThreeLabels[0], itemImage: nil)
            self.fetchDataFromRef(reference: itemRefs[1], itemLabel: self.categoryThreeLabels[1], itemImage: nil)
        }
    }
    
    func fetchItemReferences(category: String, completionBlock: @escaping(_ referenceArray: Array<String>) -> Void){
        
        StoreItems.fetchRow(categoryName: category) { (items) in
            var referenceArray = [String]()
            
            if let topItemRef = items.topItemRef{
                referenceArray.append(topItemRef)
            }
            
            if let rightItemRef = items.rightItemRef{
                referenceArray.append(rightItemRef)
            }
            
            if let leftItemRef = items.leftItemRef{
                referenceArray.append(leftItemRef)

            }
            
            completionBlock(referenceArray)
        }
        
    }
    
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func fetchDataFromRef(reference: String, itemLabel: UILabel, itemImage: UIButton?){
        let selectedItem = Firestore.firestore().document(reference)
        selectedItem.getDocument { (item, error) in
            if let itemData = item?.data(){
//                itemLabel.hideSkeleton()
                itemLabel.text = itemData["Name"]! as? String
            }
        }
    }


}
