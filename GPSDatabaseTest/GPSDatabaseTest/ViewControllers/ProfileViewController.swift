//
//  ProfileViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 15/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseStorage
import FirebaseDatabase

var profilePicture: UIImage!

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FUIAuthDelegate {

    @IBOutlet weak var username: UITextField!
    @IBAction func logout(_ sender: Any) {
        logout()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profilePictureVIew: UIImageView!
    

    @IBAction func saveProfile(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference(forURL: STORAGE_URL)
        let storageProfileRef = storageRef.child("profile").child(userID)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = profilePicture.jpegData(compressionQuality: CGFloat(JPEG_COMPRESSION_QUALITY)) else{
            return
        }
        
        saveProfilePicToUD(imageData: imageData)
                
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(storageMetadata, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
        })
        
        let ref = Database.database().reference()
        let UID: String = (Auth.auth().currentUser?.uid)!
        
        
        if let name = username.text{
            saveUserNameToUD(name: name)
            ref.child("users").child(UID).setValue(["username": name])
            username.text = ""
        }
    }
    
    func saveProfilePicToUD(imageData: Data){
        UserDefaults().set(imageData, forKey: PROFILE_PICTURE_ID)
    }
    
    func getProfilePicFromUD(){
        if let pic_data = UserDefaults.standard.object(forKey: PROFILE_PICTURE_ID){
            let picture = UIImage(data: pic_data as! Data, scale:1.0)
            profilePictureVIew.image = picture
            profilePicture = picture
        }
    }
    
    func saveUserNameToUD(name: String){
        UserDefaults.standard.set(name, forKey: USER_NAME_ID)
    }
    
    func getUserNameFromUD(){
        if let name = UserDefaults.standard.string(forKey: USER_NAME_ID){
            username.text = name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserNameFromUD()
        getProfilePicFromUD()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func logout(){
        try! Auth.auth().signOut()
        userDefault.set(false, forKey: "usersignedin")
        performSegue(withIdentifier: "ProfileToLogin", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img

        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
        }
        picker.dismiss(animated: true,completion: nil)
        profilePictureVIew.image = image
        profilePicture = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
