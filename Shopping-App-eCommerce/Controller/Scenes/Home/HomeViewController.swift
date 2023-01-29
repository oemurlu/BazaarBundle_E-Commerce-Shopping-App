//
//  HomeViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DuplicateFuncs.alertMessage(title: "ASd", message: "asdsad", vc: self)
    }
    
}
