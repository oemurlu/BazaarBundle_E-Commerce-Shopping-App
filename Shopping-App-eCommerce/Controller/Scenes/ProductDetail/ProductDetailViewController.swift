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
    let database = Firestore.firestore()

    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryProducts(selectedId: ProductDetailViewController.selectedProductID)
    }
    
    //MARK: - Functions
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
        //firestore'a eklenecek olan urun nesne olarak eklencek.
        let cartItem = CartItem(productId: ProductDetailViewController.selectedProductID, productQuantity: 1)
        let productId = cartItem.productId
        //firestore'da ayni productId var ise quantity += 1 yapilacak.
        database.collection("users").document(currentUserUid!).collection("cart").document("\(productId)").getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                self.database.collection("users").document(self.currentUserUid!).collection("cart").document("\(productId)").updateData([
                    "productQuantity": FieldValue.increment(Int64(1))
                ])
            } else {
                // Ürün Firestore veritabanında bulunamadı, ürünü ekleyin ve productQuantity değerini 1 yapın
                self.database.collection("users").document(self.currentUserUid!).collection("cart").document("\(productId)").setData([
                    //DOKUMAN ISMINI BEN VERDIM OYLE DENERSIN BI DE
                    "productID": productId,
                    "productQuantity": 1
                ])
            }
        })
        
  
        //addDocument eski yol = DOKUMAN EKLIYORDU
//        database.collection("users").document(currentUserUid!).collection("cart").addDocument(data: [
//            "productId": cartItem.productId,
//            "productQuantity": 1
//        ])
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
