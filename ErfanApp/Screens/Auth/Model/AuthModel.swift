//
//  authModel.swift
//  ErfanApp
//
//  Created by Erfan mac mini on 12/3/25.
//

import BaseModule
import SwiftUI

struct AuthModel {
    var fullName = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email = ""
    var signInLoading = false
    var registerLoading = false
    var user: UserRM?
    
    // PassKey related
    var showPassKeyRegistration = false
    var passKeyUserName = ""
    
    var emailHint: HintUIModel? = nil
    var confirmPasswordHint: HintUIModel? = nil
    
    // MARK: - Validation
    var isValidEmail: Bool {
        // Basic email validation
        let validator = Validator.email
        return validator.validate(value: email)
    }
    
    var isValidPassword: Bool {
        // Password must be at least 6 characters
        return password.count >= 6
    }
    
    var loginFormValidation: Bool {
        return isValidEmail && isValidPassword
    }
    
    var registerFormValidation: Bool {
        return isValidEmail && isValidPassword && !fullName.isEmpty && password == confirmPassword
    }
    
    mutating func validateRegister() -> Bool {
        emailHint = isValidEmail ? nil : .init(text: "Email is not valid", color: .red)
        confirmPasswordHint = password == confirmPassword ? nil : .init(text: "Passwords do not match",
                                                                        color: .red)
        return registerFormValidation
    }
}
