//
//  MenuViewController.swift
//  GPSDatabaseTest
//
//  Created by Artturi Jalli on 15/01/2020.
//  Copyright © 2020 Artturi Jalli. All rights reserved.
//

import UIKit

var name = ""

class MenuViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    
    @IBAction func saveUsername(_ sender: Any) {
        if let nick = username.text{
            name = nick
            username.text = ""
        }
        print("name saved")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
