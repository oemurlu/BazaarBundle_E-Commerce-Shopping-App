//
//  DuplicateFuncs.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 28.01.2023.
//

import UIKit

struct DuplicateFuncs {
    static func alertMessage(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        vc.present(alert, animated: true)
    }
    
    static func alertMessageWithHandler(title: String, message: String, vc: UIViewController, handler: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        vc.present(alert, animated: true)
    }
}
