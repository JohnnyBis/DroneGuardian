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

var selectedItemImage: String = ""
var selectedItemName: String = ""
var selectedItemPrice: String = ""

class ShopViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var categoryOneLabels: [UILabel]!
    @IBOutlet var categoryTwoLabels: [UILabel]!
    @IBOutlet var categoryThreeLabels: [UILabel]!
    @IBOutlet var categoryOneImages: [UIButton]!
    @IBOutlet var categoryTwoImages: [UIButton]!
    @IBOutlet var categoryThreeImages: [UIButton]!
    @IBOutlet var categoryFourLabels: [UILabel]!
    
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
        
        fetchFirstCategory()
        fetchSecondCategory()
        fetchThirdCategory()
        fetchFourthCategory()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        mainImage.isUserInteractionEnabled = true
//        mainImage.addGestureRecognizer(tapGestureRecognizer)

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
    
//    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
//    {
//        performSegue(withIdentifier: "goToItemFromShop", sender: self)
//    }
    
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
    
    func fetchFourthCategory(){
        fetchItemReferences(category: "Category 4") { (itemRefs) in
            print(itemRefs)
            self.fetchDataFromRef(reference: itemRefs[0], itemLabel: self.categoryFourLabels[0], itemImage: nil)
            self.fetchDataFromRef(reference: itemRefs[1], itemLabel: self.categoryFourLabels[1], itemImage: nil)
            self.fetchDataFromRef(reference: itemRefs[2], itemLabel: self.categoryFourLabels[2], itemImage: nil)

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
                let name = itemData["Name"] as? String
                
//                self.categoryOneItems.append(name!)
                itemLabel.text = name
            }
        }
    }
    
    func fetchDataToSend(reference: String){
        let selectedItem = Firestore.firestore().document(reference)
        selectedItem.getDocument { (item, error) in
            if let itemData = item?.data(){
                let price = itemData["Price"] as? String
                let name = itemData["Name"] as? String
                let url = itemData["Url"] as? String
                print(price!)
                selectedItemName = name!
                selectedItemImage = url!
                selectedItemPrice = price!
            }
            self.performSegue(withIdentifier: "goToItemFromShop", sender: self)
        }
    }
    
    
    
    @IBAction func itemButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1, 2, 3:
            fetchItemReferences(category: "Category 1") { (itemRefs) in
                if sender.tag == 1{
                    self.fetchDataToSend(reference: itemRefs[0])
                    
                }else if sender.tag == 2{
                    self.fetchDataToSend(reference: itemRefs[1])
                    
                }else{
                    self.fetchDataToSend(reference: itemRefs[2])
                    
                }
            }
            
            break
            
        case 4:
            fetchItemReferences(category: "Category 2") { (itemRefs) in
                self.fetchDataToSend(reference: itemRefs[0])
            }

            break
            
        case 5, 6:
            fetchItemReferences(category: "Category 3") { (itemRefs) in
                if sender.tag == 5{
                    self.fetchDataToSend(reference: itemRefs[0])
                
                }else{
                    self.fetchDataToSend(reference: itemRefs[1])
        
                }

            }

            break
            
        case 7, 8, 9:
            fetchItemReferences(category: "Category 4") { (itemRefs) in
                if sender.tag == 7{
                    self.fetchDataToSend(reference: itemRefs[0])
                    
                }else if sender.tag == 8{
                    self.fetchDataToSend(reference: itemRefs[1])
                    
                }else{
                    self.fetchDataToSend(reference: itemRefs[2])
                    
                }
            }

            break
            
        default:
            print("Unknown language")
            return
        }
    }
    

}
