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
import Kingfisher

var selectedCells: [String] = []
var selectedLicense: [String] = []

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    @IBOutlet weak var licenseCollectionView: UICollectionView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage!
    var pictureType: String = ""
    var chosenLicenses: [String] = []
    
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
//        status.isSelected = true
        licenseCollectionView.delegate = self
        licenseCollectionView.dataSource = self
        licenseCollectionView.allowsSelection = true
        status.isSelected = true

//        chosenDrones.layer.borderWidth = 1
//        chosenDrones.layer.borderColor = UIColor.orange.cgColor
//        chosenDrones.layer.cornerRadius = 5
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchChosenDrones()
//        profileImage.isSkeletonable = true
//        profileImage.showAnimatedGradientSkeleton()
        fetchChosenLicense()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        User.fetchUserData(uid: uid!) { (user) in
            
            if user.licenses == []{
                self.registeredLicenses.text = "No licenses registered"
                DispatchQueue.main.async {
                    self.licenseCollectionView.reloadData()
                }
            }else{
                self.registeredLicenses.text = "Your licenses:"
                self.chosenLicenses = user.licenses
                DispatchQueue.main.async {
                    self.licenseCollectionView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchUserData(){
        User.fetchUserData(uid: uid!) { (user) in
            let url = user.imageUrl
            if url != ""{
                let imageUrl = URL(string: url!)
                self.profileImage.kf.setImage(with: imageUrl)
            }
            
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
//                if licenses != []{
//                    self.registeredLicenses.text = "\(licenses)"
//                    self.heighForLabel(label: self.registeredLicenses, text: "\(licenses)")
//                }
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
    
    @IBAction func addLicensePictureButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        pictureType = "License Url"
        
    }
    
    
    @IBAction func addInsurancePictureButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
        pictureType = "Insurance Url"
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
        
        status.setTitle("Online", for: UIControlState.selected)
        status.setTitle("Offline", for: UIControlState.normal)

        if status.isSelected == false{
            status.isSelected = true
            
            DataService.ds.REF_USERS.document(uid!).updateData(["Status": "Online"])
        }else{
            status.isSelected = false
            
            DataService.ds.REF_USERS.document(uid!).updateData(["Status": "Offline"])
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chosenLicenses.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = licenseCollectionView.dequeueReusableCell(withReuseIdentifier: "licenseCell", for: indexPath) as! CertificationCollectionViewCell
        cell.licenseName.text = chosenLicenses[indexPath.row]
        DataService.ds.REF_USERS.document(uid!).getDocument { (doc, error) in
            if error != nil{
                print(error!)
            }else{
                if let document = doc{
                    
                    let type = document.data()
                    guard let faa107 = type?["107"] else {
                        print("Type not found")
                        return
                    }
                    guard let faa333 =  type?["333"] else {
                        print("Type not found")
                        return
                    }
                    guard let tp =  type?["TP"] else {
                        print("Type not found")
                        return
                    }
                    
                    if cell.licenseName.text == "FAA Part 107 Certification"{
                        cell.licenseImage.kf.setImage(with: URL(string: faa107 as! String))
                        
                    }else if cell.licenseName.text == "FAA Section 333 Exemption"{
                        cell.licenseImage.kf.setImage(with: URL(string: faa333 as! String))
                        
                    }else{
                        cell.licenseImage.kf.setImage(with: URL(string: tp as! String))
                        
                    }
                }

            }
            self.licenseCollectionView.reloadData()
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        selectedPilotID = dronePilot[indexPath.row].userID
//        performSegue(withIdentifier: "goToSetupFromMap", sender: self)
//    }
    
    @IBAction func changePictureButtonPressed(_ sender: UIButton) {
        pictureType = "Profile Url"
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if pictureType == "Profile Url"{
                profileImage.contentMode = .scaleAspectFit
                profileImage.image = pickedImage
                uploadImage(pickedImage, true) { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DataService.ds.REF_USERS.document(uid!).updateData(["Profile Url": url!])
                }
            }else if pictureType == "License Url"{
                newImage = pickedImage
                performSegue(withIdentifier: "fromProfileToInsurancePicture", sender: self)                
                
            }else{
                uploadImage(pickedImage, false) { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    DataService.ds.REF_USERS.document(uid!).updateData([self.pictureType: url!])
                }
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage, _ profilePicture: Bool, completionBlock: @escaping (_ url: String?, _ errorMessage: String?) -> Void) {
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        let storageRef = Storage.storage().reference()
        var specificRef: StorageReference
        
        if profilePicture == true{
            specificRef = storageRef.child("Profile").child(uid!)
        }else{
            specificRef = storageRef.child("Documents")
        }
        
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
