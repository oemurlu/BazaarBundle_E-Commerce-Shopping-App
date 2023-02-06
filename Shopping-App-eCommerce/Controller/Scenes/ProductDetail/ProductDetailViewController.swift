//
//  ProductDetailViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

import UIKit
import Alamofire
import SDWebImage

class ProductDetailViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productSalesCount: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantitityLabel: UILabel!
    
    static var selectedProductID: Int  = 0
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryProducts(selectedId: ProductDetailViewController.selectedProductID)
    }
    
    //MARK: - Functions
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
    }
    
    func fetchCategoryProducts(selectedId: Int) {
//        print("\(K.Network.categoryURL)/\(category)")
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
               print("CASE FAILURE: ",error)
           }
       }
   }
}

