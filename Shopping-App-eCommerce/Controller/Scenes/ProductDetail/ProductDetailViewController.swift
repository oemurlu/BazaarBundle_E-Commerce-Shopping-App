//
//  ProductDetailViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

import UIKit
import Alamofire
import SDWebImage
import Firebase
import FirebaseFirestore

class ProductDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productSalesCount: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var numberOfClicksOnAddButton = 0
    
    static var selectedProductID: Int  = 0
    
    var authUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    let currentUserUid = Auth.auth().currentUser?.uid

    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryProducts(selectedId: ProductDetailViewController.selectedProductID)
    }
    
    //MARK: - Functions
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
        //firestore'a eklenecek olan urun nesne olarak eklencek.
        numberOfClicksOnAddButton += 1
        let cartItem = CartItem(productId: ProductDetailViewController.selectedProductID)
        let database = Firestore.firestore()
        
        //oe deneme
        if numberOfClicksOnAddButton == 1 {
            
        }
        database.collection("users").document(currentUserUid!).collection("cart").addDocument(data: [
            "productId": cartItem.productId,
            "productQuantity": 1
        ])
    }
    
    func fetchCategoryProducts(selectedId: Int) {
        AF.request("\(K.Network.baseURL)/\(selectedId)").response { response in
       switch response.result {
       case .success(_):
           do {
               let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
               DispatchQueue.main.async {
                   self.productImage.sd_setImage(with: URL(string: productData.image), placeholderImage: UIImage(systemName: "photo"))
                   self.productRate.text = "⭐️\(productData.rating.rate)"
                   self.productPrice.text = "$\(productData.price)"
                   self.productTitle.text = productData.title
                   self.productDescription.text = productData.description
                   self.productSalesCount.text = "\(productData.rating.count) sold"
               }
               } catch
               let error {
                   print("DECODING ERROR:",error)
               }
            case .failure(let error):
            print("NETWORK ERROR: ",error)
           }
       }
   }
    
    func updateCart(productId: Int) {
        
    }
}

// Swift dili ile iOS uygulamasi yapiyorum. Yukaridaki gibi bir dosyam var. Bu viewcontroller, urun detaylarini gosteriyor ve addBasketButtonClicked butonuna tiklandiginda cart'ta bulunan itemleri firestore'ye gondermek istiyorum. Bunu nasil yapacagim?
