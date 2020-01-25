//
//  LoginViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 22/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {

    @IBAction func loginAction(_ sender: Any) {
        if userDefault.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "LoginToMenu", sender: self)
        }
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        let authViewController = authUI?.authViewController()
        present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //  Check if there was an error
        guard error == nil else {
            print(error?.localizedDescription as Any)
            userDefault.set(true, forKey: "usersignedin")
            userDefault.synchronize()
            return
        }
        performSegue(withIdentifier: "LoginToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
