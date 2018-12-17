//
//  SignUpViewController.swift
//  Salafesy
//
//  Created by Loay on 12/5/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase

class SignUpViewController: UIViewController {

    // Variables & Refrences
    var ref: DatabaseReference!
    
    var defaultBottomMargin:CGFloat = 0.0
    var keyboardDidShow:Bool = false
    
    // @brief The handler for the auth state listener, to allow cancelling later.
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
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
        usernameField.setBottomBorder()
        emailField.setBottomBorder()
        passwordField.setBottomBorder()
        password2Field.setBottomBorder()
        registerButton.setRoundCorner()
    }

    @IBAction func Register(_ sender: UIButton) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let pass2 = password2Field.text
        
        if password != pass2{
            errorLabel.text = "Password Not Matched"
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in self.errorLabel.text = ""})
            passwordField.text = ""
            password2Field.text = ""
            return
        }
        
        if !(email?.isEmpty)! && !(username?.isEmpty)!{
            // Register the user
            Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in
                // [START_EXCLUDE]
                guard let email = authResult?.user.email, error == nil else {
                    //self.showMessagePrompt(error!.localizedDescription)
                    return
                }
                
                let user = Auth.auth().currentUser
                self.ref.child("users").child((user?.uid)!).setValue(["email": email, "username":username])
            
                self.navigationController?.popViewController(animated: true)
                // [END_EXCLUDE]
                //guard let user = authResult?.user else { return }
            }
        }else{
            errorLabel.text = "Please Fill all The Fields"
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in self.errorLabel.text = ""})
        }
    }
    
    // To hide keyboard when exiting textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        password2Field.resignFirstResponder()
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
                let rect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                let keyboardY = rect.origin.y
                let buttonY = registerButton.frame.origin.y + registerButton.frame.height + 20
                let diff = abs(keyboardY - buttonY)
                let targetOffset = bottomMargin.constant + diff
                //print(keyboardY, buttonY, diff, targetOffset, bottomMargin.constant, registerButton.frame.height)
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
