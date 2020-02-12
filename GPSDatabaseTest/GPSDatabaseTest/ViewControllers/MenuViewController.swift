//
//  MenuViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 15/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseStorage

var name = ""
var profilePicture: UIImage!

class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FUIAuthDelegate {

    @IBOutlet weak var username: UITextField!
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
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
        let storageRef = Storage.storage().reference(forURL: "gs://ioslocationdatabase.appspot.com/")
        let storageProfileRef = storageRef.child("profile").child(userID)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        guard let imageData = profilePicture.jpegData(compressionQuality: 0.4) else{
            return
        }
        
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(storageMetadata, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
        })
        
        print(userID)
        if let nick = username.text{
            name = nick
            username.text = ""
        }
        print("name saved")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profilePictureVIew.image = image
        profilePicture = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}