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
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var authUser: FirebaseAuth.User? {
//        return Auth.auth().currentUser
        Auth.auth().currentUser
    }
    
    private let database = Firestore.firestore()
    
    //MARK: - Interaction handlers
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, let username = usernameLabel.text {
            if isPasswordsMatch(password: password, confirmPassword: confirmPassword) {
                //if passwords match, go to Authentication. else, make alert.
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        DuplicateFuncs.alertMessage(title: "ERROR", message: error.localizedDescription, vc: self)
                    } else {
                        //firestore denemesi
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = self.usernameLabel.text
                        changeRequest?.commitChanges(completion: { error in
                            if let error = error {
                                DuplicateFuncs.alertMessage(title: "FIRESTORE ERROR", message: error.localizedDescription, vc: self)
                            }
                        })
                        guard let uid = authResult?.user.uid else { return }
                        
                        let cart: [Int : Int] = [:]
                        
                        let user = User(id: uid, username: username, email: email, cart: cart)
//                        self.database.collection("users").document(uid).setData(user.dictionary) { error in
//                            if let error = error {
//                                print("ERROR: DATABASE ADD")
//                                DuplicateFuncs.alertMessage(title: "ERROR", message: error.localizedDescription, vc: self)
//                            }
//                            else {
//                                DuplicateFuncs.alertMessage(title: "HELAL", message: "ELSE CALISIYOR", vc: self)
//                            }
//                        }
                        self.database.collection("users").document(uid).collection("userInfo").document(uid).setData([
                            "username": username,
                            "email": email,
                            "id": uid
                        ]) { error in
                            if let error = error {
                                DuplicateFuncs.alertMessage(title: "ERROR", message: error.localizedDescription, vc: self)
                            }
                        }
                        
                        self.sendVerificationMail()
                        DuplicateFuncs.alertMessageWithHandler(title: "Verify your email", message: "Verification mail sent", vc: self) {
                            self.performSegue(withIdentifier: K.Segues.registerToLogin, sender: self)
                        }
                    }
                }
            } else {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Passwords do not match!", vc: self)
            }
        }
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
}
