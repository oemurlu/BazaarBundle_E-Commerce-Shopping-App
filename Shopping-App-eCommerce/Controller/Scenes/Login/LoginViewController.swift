//
//  LoginViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private var authUser: User? {
        return Auth.auth().currentUser
    }

    func isEmailVerified() -> Bool {
        if authUser != nil && !authUser!.isEmailVerified { //buradaki 'isEmailVerified' Firebase'den geliyor.
            // User is available, but their email is not verified.
            return true
        }
        return false
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("signIn Firebase error", e.localizedDescription)
                    DuplicateFuncs.alertMessage(title: "ERROR", message: e.localizedDescription, vc: self)
                } else {
                    if self.isEmailVerified() {
                        DuplicateFuncs.alertMessage(title: "Email not verified", message: "Please verify your e-mail", vc: self)
                    } else {
                        self.performSegue(withIdentifier: K.Segues.loginToHome, sender: self)
                    }

                }
            }
        }
    }
}

