//
//  MainMenuViewController.swift
//  
//
//  Created by Artturi Jalli on 16/02/2020.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class MainMenuViewController: UIViewController, FUIAuthDelegate {

    @IBAction func ProfileButton(_ sender: Any) {
        performSegue(withIdentifier: "MainMenuToProfile", sender: self)
    }
    @IBAction func LocalChatButton(_ sender: Any) {
        performSegue(withIdentifier: "MainMenuToMessage", sender: self)
    }
    @IBAction func MeetFriendsButton(_ sender: Any) {
        performSegue(withIdentifier: "MainMenuToFriend", sender: self)
    }
    @IBAction func SignOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        userDefault.set(false, forKey: "usersignedin")
        performSegue(withIdentifier: "MainMenuToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
