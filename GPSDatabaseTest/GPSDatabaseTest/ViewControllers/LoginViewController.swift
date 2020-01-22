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
        // Get the default Auth UI Object
        if userDefault.bool(forKey: "usersignedin") {
            performSegue(withIdentifier: "LoginToMenu", sender: self)
        }
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // Log the error
            return
        }
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        // Get a reference to the auth UI view contoller
        let authViewController = authUI?.authViewController()
        
        // Show it.
        present(authViewController!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //  Check if there was an error
        guard error == nil else {
            print(error?.localizedDescription as Any)
            userDefault.set(true, forKey: "usersignedin")
            userDefault.synchronize()
            return
        }
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "LoginToMenu", sender: self)
        
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
