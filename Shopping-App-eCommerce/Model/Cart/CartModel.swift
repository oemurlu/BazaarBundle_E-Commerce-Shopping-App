//
//  CartModel.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 7.02.2023.
//

import Foundation
import Firebase
import FirebaseAuth

struct CartItem {
    let productId: Int
//    let userId: FirebaseAuth.User?
//    let userId: String
    let productQuantity = 1
}
