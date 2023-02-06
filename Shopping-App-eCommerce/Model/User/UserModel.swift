//
//  UserModel.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 6.02.2023.
//

import Foundation

struct User: Codable {
    var id: String?
    var username: String?
    var email: String?
    var cart: [Int : Int]?
}
