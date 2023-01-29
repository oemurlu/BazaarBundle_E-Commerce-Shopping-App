//
//  RegisterViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var authUser: User? {
        return Auth.auth().currentUser
    }
    
    //MARK: - Functions
    private func sendVerificationMail() {
        if authUser != nil && !authUser!.isEmailVerified {
            authUser?.sendEmailVerification(completion: { error in
                if let error = error {
                    DuplicateFuncs.alertMessage(title: "ERROR", message: error.localizedDescription, vc: self)
                }
            })
        } else {
            // Either the user is not available, or the user is already verified.
            DuplicateFuncs.alertMessage(title: "ERROR", message: "e-mail already verified", vc: self)
        }
    }
    
    private func isPasswordsMatch(password: String, confirmPassword: String) -> Bool {
        if let password = passwordTextField.text, let passwordConfirm = confirmPasswordTextField.text {
            if password == passwordConfirm {
                return true
            }
        }
        return false
    }
    
    //MARK: - Interaction handlers
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            if isPasswordsMatch(password: password, confirmPassword: confirmPassword) { //if passwords match, go to Authentication. else, make alert.
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        DuplicateFuncs.alertMessage(title: "ERROR", message: error.localizedDescription, vc: self)
                    } else {
                        self.sendVerificationMail()
                        DuplicateFuncs.alertMessageWithHandler(title: "Verify your email", message: "Verification mail sent", vc: self) {
                            self.performSegue(withIdentifier: K.registerToLogin, sender: self)
                        }
                    }
                }
            } else {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Passwords do not match!", vc: self)
            }
        }
    }
    
    
    
    
}
