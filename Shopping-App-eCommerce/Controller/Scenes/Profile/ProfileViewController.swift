//
//  ProfileViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 11.02.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileUserEmailLabel: UILabel!
    
    let currentUser = Auth.auth().currentUser
    
    var email: String?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - bsi handlers
    @IBAction func uploadProfilePhotoButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        signOut()
    }
    
    //MARK: - Functions
    func signOut() {
        do {
            try Auth.auth().signOut()
            DuplicateFuncs.alertMessageWithHandler(title: "Success", message: "Logged out", vc: self) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.welcomeVC)
                vc.navigationItem.hidesBackButton = true
                self.show(vc, sender: self)
            }
            
        } catch let error {
            DuplicateFuncs.alertMessage(title: "Error", message: error.localizedDescription, vc: self)
        }
    }
    
}
