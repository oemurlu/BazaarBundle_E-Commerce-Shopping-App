//
//  Constants.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

struct K {
    struct Segues {
        static let loginToHome = "loginToHome"
        static let registerToLogin = "registerToLogin"
        static let forgotToLogin = "forgotToLogin"
        static let categoryTableView = "CategoryTableViewVC"
        static let productDetailViewController = "productDetailViewController"
        static let loginToForgot = "loginToForgot"
    }
    
    struct StoryboardID {
        static let welcomeVC = "WelcomeVC"
    }
    
    struct CollectionViews {
        static let topCollectionViewNibNameAndIdentifier = "CategoriesCollectionViewCell"
        static let bottomCollectionViewNibNameAndIdentifier = "ProductsCollectionViewCell"
    }
    
    struct Network {
        static let baseURL = "https://fakestoreapi.com/products"
        static let categoryURL = "https://fakestoreapi.com/products/category"
        static let categoriesURL = "https://fakestoreapi.com/products/categories"
    }
    
    struct TableView {
        static let categorizedTableViewCell = "CategorizedTableViewCell"
        static let cartTableViewCell = "CartTableViewCell"
    }
    
}
