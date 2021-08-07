//
//  LoginManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import Foundation

struct LoginManager {
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isPasswordVerified(confirmation: String) -> Bool {
       return false
    }
    
}
