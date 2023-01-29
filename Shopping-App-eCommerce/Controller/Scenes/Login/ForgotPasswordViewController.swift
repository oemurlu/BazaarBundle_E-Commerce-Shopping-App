//
//  ForgotPasswordViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 28.01.2023.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendNewPasswordButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text {
            if email == "" {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Please enter a valid email", vc: self)
            } else {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        DuplicateFuncs.alertMessage(title: "Network error", message: error.localizedDescription, vc: self)
                    } else {
                        DuplicateFuncs.alertMessageWithHandler(title: "Success", message: "Please check your email", vc: self) {
                            self.performSegue(withIdentifier: K.forgotToLogin, sender: self)
                        }
                    }
                }
            }
        }
    }
}
