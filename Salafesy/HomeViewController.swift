//
//  HomeViewController.swift
//  Salafesy
//
//  Created by Loay on 12/5/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase


class HomeViewController: UIViewController {

    // Variables
    var ref:DatabaseReference!
    
    lazy var user:UserAccount = UserAccount()
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase refrence
        ref = Database.database().reference()
        
        // Get user's info
        getUserInfo()
    }
    
    public func getUserInfo() {
        // Get user's info
        var username = ""{
            didSet{
                usernameLabel.text = username
            }
        }
        var email = ""
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! NSDictionary
            username = value["username"] as! String
            email = value["email"] as! String
            self.user = UserAccount(username, email)
        })
    }

}
