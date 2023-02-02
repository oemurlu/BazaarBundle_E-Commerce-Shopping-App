//
//  Product.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 30.01.2023.
//

import Foundation

struct ProductData: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
    let category: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}

//enum Category: String, Codable {
//    case electronics = "electronics"
//    case jewelery = "jewelery"
//    case menSClothing = "men's clothing"
//    case womenSClothing = "women's clothing"
//}

