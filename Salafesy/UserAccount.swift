//
//  UserAccount.swift
//  Salafesy
//
//  Created by Loay on 12/5/18.
//  Copyright © 2018 Loay Productions. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase

class UserAccount{
    
    // Variables
    private var username:String
    private var email:String
    
    // Constructor
    init(){
        self.username = ""
        self.email = ""
    }
    init(_ us:String,_ em:String) {
        
        self.username = us
        self.email = em
    }
    
    // Setters
    public func setUsername(us:String){
        
        self.username = us
    }
    
    public func setEmail(em:String){
        
        self.email = em
    }
    
    // Getters
    public func getUsername()->String{
        
        return self.username
    }
    
    public func getEmail()->String{
        
        return self.email
    }
    
    
}
