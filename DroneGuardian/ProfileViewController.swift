//
//  ProfileViewController.swift
//  DroneGuardian
//
//  Created by Gianmaria Biselli on 7/24/18.
//  Copyright © 2018 Gianmaria Biselli. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import SkeletonView

var selectedCells: [String] = []
var selectedLicense: [String] = []

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var insuranceNumber: UITextField!
    @IBOutlet weak var coverage: UITextField!
    @IBOutlet weak var chosenDrones: UILabel!
    @IBOutlet weak var idNumber: UITextField!
    @IBOutlet weak var milesAvailability: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weekdaysButton: UIButton!
    @IBOutlet weak var weekendsButton: UIButton!
    @IBOutlet weak var droneFeature: UILabel!
    @IBOutlet weak var selectDroneButton: UIButton!
    @IBOutlet weak var registeredLicenses: UILabel!
    @IBOutlet weak var status: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var pictureType: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        fullName.delegate = self
        email.delegate = self
        address.delegate = self
        phoneNumber.delegate = self
        companyName.delegate = self
        insuranceNumber.delegate = self
        coverage.delegate = self
        milesAvailability.delegate = self
        idNumber.delegate = self
        chosenDrones.text = "My drone model"
        fetchUserData()
        scrollView.keyboardDismissMode = .onDrag
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        status.isSelected = true
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchChosenDrones()
//        profileImage.isSkeletonable = true
//        profileImage.showAnimatedGradientSkeleton()
        fetchChosenLicense()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserData(){
        User.fetchUserData(uid: uid!) { (user) in
            self.username.text = user.username
            self.fullName.text = user.username
            self.email.text = user.email
            self.address.text = user.address
            self.phoneNumber.text = user.phoneNumber
            self.companyName.text = user.company
            self.insuranceNumber.text = user.insurance
            self.coverage.text = user.coverage
            self.milesAvailability.text = user.milesAvailable
            self.weekendsButton.isSelected = user.weekends
            self.weekdaysButton.isSelected = user.weekdays
            self.idNumber.text = user.patentID
            
//            if user.status != ""{
//                self.accountStatus.titleLabel?.text = user.status
//            }else{
//                DataService.ds.REF_USERS.document(uid!).setData(["Status": "Online"], merge: true)
//                self.accountStatus.titleLabel?.text = "Online"
//            }
            
            if user.pilot == false{
                self.droneFeature.isHidden = true
                self.chosenDrones.isHidden = true
                self.selectDroneButton.isHidden = true
                
            }
            if user.drones == []{
                self.chosenDrones.text = "My Chosen Drones"
                
            }else{
                self.chosenDrones.text = "\(user.drones)"
                self.heighForLabel(label: self.chosenDrones, text: "\(user.drones)")
                
            }
            
            if user.licenses == []{
                self.registeredLicenses.text = "No licenses registered"
            }else{
                let list = user.licenses
                print(list)
                self.registeredLicenses.text = "\(list)"
                self.heighForLabel(label: self.registeredLicenses, text: "\(list)")
            }
            
            
            
        }
    }
    
    func heighForLabel(label: UILabel, text: String){
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DataService.ds.REF_USERS.document(uid!).updateData(["Full Name":fullName.text!, "Email":email.text!, "Address":address.text!, "Phone":phoneNumber.text!, "Company":companyName.text!, "Insurance":insuranceNumber.text!, "Coverage":coverage.text!, "Miles available": milesAvailability.text!, "Patent ID": idNumber.text!])
    }
    
    func fetchChosenDrones(){
        DataService.ds.REF_USERS.document(uid!).getDocument { (document, error) in
            if error != nil{
                print(error!)
            }else{
                let user = document?.data()
                let drones = user!["Drones"] as! NSArray
                print(drones)
                if drones == []{
                    self.chosenDrones.text = "My Chosen Drones"
                }else{
                    self.chosenDrones.text = "\(drones)"
                    self.heighForLabel(label: self.chosenDrones, text: "\(drones)")
                }
            }
        }
    }
    
    func fetchChosenLicense(){
        DataService.ds.REF_USERS.document(uid!).getDocument { (document, error) in
            if error != nil{
                print(error!)
            }else{
                let user = document?.data()
                let licenses = user!["License"] as! NSArray
                print(licenses)
                if licenses != []{
                    self.registeredLicenses.text = "\(licenses)"
                    self.heighForLabel(label: self.registeredLicenses, text: "\(licenses)")
                }
            }
        }
    }

    @IBAction func weekdaysButtonPressed(_ sender: UIButton) {
        if weekdaysButton.isSelected == false{
            weekdaysButton.isSelected = true
            DataService.ds.REF_USERS.document(uid!).setData(["Weekdays": true], merge: true)
            
        }else{
            weekdaysButton.isSelected = false
            DataService.ds.REF_USERS.document(uid!).setData(["Weekdays": false], merge: true)

        }
        
        
    }
    
    @IBAction func weekendsButtonPressed(_ sender: UIButton) {
        if weekendsButton.isSelected == false{
            weekendsButton.isSelected = true
            DataService.ds.REF_USERS.document(uid!).setData(["Weekends": true], merge: true)
        }else{
            weekendsButton.isSelected = false
            DataService.ds.REF_USERS.document(uid!).setData(["Weekends": false], merge: true)

        }
    }
    
    @IBAction func addPictureButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        pictureType = "License Url"
        
    }
    
    @IBAction func addInsurancePictureButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        pictureType = "Insurance Url"
    }
    
    func uploadProfileImage(image: UIImage, name: String){
        FireStorageImageUpload().uploadImage(image, progressBlock: { (percentage) in
        }, completionBlock: { (fileUrl, error) in
            if error != nil{
                print("ERROR: " + error!)
            }
            DataService.ds.REF_USERS.document(uid!).updateData([name: "\(fileUrl!)"], completion: { (error) in
                if error != nil{
                    print(error!)
                }
            })
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if pictureType == "Profile Image"{
                profileImage.contentMode = .scaleAspectFill
                profileImage.image = pickedImage
                selectedImage = pickedImage
                uploadProfileImage(image: selectedImage, name: pictureType)
            }else{
                selectedImage = pickedImage
                uploadProfileImage(image: selectedImage, name: pictureType)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        }
        catch {
            print("error: there was a problem signing out")
        }
    }
    
    @IBAction func statusButtonPressed(_ sender: UIButton) {
        if status.isSelected == false{
            status.isSelected = true
            status.titleLabel?.text = "Online"
            DataService.ds.REF_USERS.document(uid!).updateData(["Status": "Online"])
        }else{
            status.isSelected = false
            status.titleLabel?.text = "Offline"
            DataService.ds.REF_USERS.document(uid!).updateData(["Status": "Online"])
            
        }
        
    }
    
}
