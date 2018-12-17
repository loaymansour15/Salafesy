//
//  ViewController.swift
//  Salafesy
//
//  Created by Loay on 9/26/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class LoginController: UIViewController {
    
    // Variables & Refrences
    var ref: DatabaseReference!
    
    var defaultBottomMargin:CGFloat = 0.0
    var keyboardDidShow:Bool = false
    
    // @brief The handler for the auth state listener, to allow cancelling later.
    var handle: AuthStateDidChangeListenerHandle?
    
    //    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Firebase refrence
        ref = Database.database().reference()
        
        // Save bottom margin
        defaultBottomMargin = bottomMargin.constant
        
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Set fields and buttons shapes, UI Thing with extensions
        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        loginButton.setRoundCorner()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Listen for user when login
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("User logged in")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Listen for user when logout
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // Login button
    @IBAction func LoginButton(_ sender: UIButton) {
        let email = self.emailField.text
        let password = self.passwordField.text
        if  !(email?.isEmpty)! && !(password?.isEmpty)!{
            // [START headless_email_auth]
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error {
                    self.showAlert(title: "Invalid Access", msg: "Invalid Username or Password", duration: 1.5)
                    print(error.localizedDescription);return}
                
                // Open home view
                guard let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else{return}
                self.present(homeViewController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(homeViewController, animated: true)// with back button
            }
        } else {
            self.showAlert(title: "Empty Fields", msg: "Please type your Email and Password", duration: 1.5)
        }
    }
    
    // To hide keyboard when exiting textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        //        LogoImage.isHidden = false
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.95, animations: {
            self.bottomMargin.constant = self.defaultBottomMargin
        })
        keyboardDidShow = false
    }
    
    // Show keyboard
    @objc func keyboardWillShow(notification:NSNotification){
        
        if keyboardDidShow == false{
            
            if let info = notification.userInfo{
                
                let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                let targetY = view.frame.size.height - rect.height
                
                let buttonY = signUpButton.frame.origin.y
                
                let diff = abs(targetY - buttonY)
                
                let targetOffset = bottomMargin.constant + diff
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.bottomMargin.constant = targetOffset
                    self.view.layoutIfNeeded()
                })
                
                //                if (LogoImage.frame.origin.y + LogoImage.frame.size.height) >= usernameField.frame.origin.y{
                //                    LogoImage.isHidden = true
                //                }
                
                keyboardDidShow = true
            }
        }
    }
    
    // Show alet to user
    func showAlert(title : String, msg : String, duration: Float){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
}

// Extensions

extension UITextField{
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.backgroundColor = .clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = .gray
        self.addSubview(borderLine)
    }
}

extension UIButton{
    
    func setRoundCorner(){
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

