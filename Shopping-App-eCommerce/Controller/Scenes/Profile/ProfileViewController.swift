//
//  ProfileViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 11.02.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileUserEmailLabel: UILabel!
    
    private let currentUser = Auth.auth().currentUser
    private let imagePicker = UIImagePickerController()
    private let storage = Storage.storage()
    private let database = Firestore.firestore()
    private let currentUserUid = Auth.auth().currentUser?.uid
    
    private var selectedImage: UIImage?
    private var email: String?
    private var username: String?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height / 2
        profilePictureImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProfilePhotoFromFirebase()
        fetchUserNameAndEmail()
    }
    
    //MARK: - Interaction handlers
    @IBAction func uploadProfilePhotoButtonPressed(_ sender: UIButton) {
        //resim secme islemi
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
    
    func uploadProfilePhotoToFirebase() {
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let storageRef = storage.reference().child("profile_photos").child("\(String(describing: currentUserUid)).jpg")
        let uploadTask = storageRef.putData(imageData) { (metadata, error) in
            if error != nil {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Error uploading profile photo: \(String(describing: error?.localizedDescription))", vc: self)
                return
            }
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    DuplicateFuncs.alertMessage(title: "ERROR", message: "Error getting download URL for profile photo", vc: self)
                    return
                }
                let downloadURL = url!.absoluteString
                //burada resmin indirme url'sini firestore'ye kaydedecegiz.
                self.database.collection("users").document(self.currentUserUid!).collection("userInfo").document(self.currentUserUid!).setData([
                    "profile_photo_url": downloadURL
                ], merge: true) { error in
                    if error != nil {
                        print("error saving profile photo URL to Firestore: \(String(describing: error?.localizedDescription))")
                        DuplicateFuncs.alertMessage(title: "ERROR", message: "Failed to save profile photo.", vc: self)
                        return
                    }
                    DuplicateFuncs.alertMessage(title: "Success", message: "Profile photo successfully saved.", vc: self)
                }
            }
        }
        uploadTask.resume()
    }
    
    func fetchProfilePhotoFromFirebase() {
        database.collection("users").document(currentUserUid!).collection("userInfo").document(currentUserUid!).getDocument { document, error in
            if error != nil {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Failed to fetch profile photo: \(String(describing: error?.localizedDescription))", vc: self)
                return
            }
            guard let document = document, document.exists else { return }
            if let profilePhotoURL = document.get("profile_photo_url") as? String {
                let storageRef = Storage.storage().reference(forURL: profilePhotoURL)
                storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error downloading profile photo: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    guard let imageData = data else { return }
                    self.profilePictureImageView.image = UIImage(data: imageData)
                }
            } else {
                self.profilePictureImageView.image = UIImage(systemName: "person.circle.fill")
            }
        }
    }
    
    func fetchUserNameAndEmail() {
        database.collection("users").document(currentUserUid!).collection("userInfo").document(currentUserUid!).getDocument { document, error in
            if error != nil {
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Failed to fetch username and email", vc: self)
                return
            } else {
                guard let document = document, document.exists else { return }
                if let profileEmail = document.get("email") as? String {
                    self.profileUserEmailLabel.text = profileEmail
                }
                if let profileUsername = document.get("username") as? String {
                    self.profileUsernameLabel.text = profileUsername
                }
            }
        }
    }
    
}

//MARK: - Extensions
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            profilePictureImageView.image = selectedImage
            dismiss(animated: true)
            uploadProfilePhotoToFirebase()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    //burayi silme
}
