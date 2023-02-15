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
    
    static var selectedProductID: Int  = 0
    
    private let currentUserUid = Auth.auth().currentUser?.uid
    private let database = Firestore.firestore()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryProducts(selectedId: ProductDetailViewController.selectedProductID)
    }
    
    //MARK: - Interaction handlers
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
        updateCart(productId: ProductDetailViewController.selectedProductID, quantity: 1)
    }
    
    //MARK: - Functions
    func updateCart(productId: Int, quantity: Int) {
        let userRef = database.collection("users").document(currentUserUid!)
        //ayni urun sepette var ise urunun quantity 1 artirilacak.
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data(), let _ = data["\(productId)"] {
                    userRef.updateData(["\(productId)" : FieldValue.increment(Int64(1))])
                    DuplicateFuncs.alertMessage(title: "Caution", message: "The quantity of the product in the cart has been increased by 1.", vc: self)
                } else {
                    userRef.updateData(["\(productId)" : quantity])
                    DuplicateFuncs.alertMessage(title: "Success", message: "The product has been successfully added to the cart.", vc: self)
                }
            } else {
                print("document = document olmadi: \(String(describing: error?.localizedDescription)) ve doc: \(String(describing: document))")
            }
        }
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
}
