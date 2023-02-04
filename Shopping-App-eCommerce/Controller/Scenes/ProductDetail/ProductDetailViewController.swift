//
//  ProductDetailViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

import UIKit
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
    static var filteredProduct: [ProductModel] = []
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterProduct(id: ProductDetailViewController.selectedProductID)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Functions
    @IBAction func addBasketButtonClicked(_ sender: UIButton) {
    }
    
    
    // Tekrardan model yazip API istek gondermek yerine tum urunleri zaten cekmistim. O yuzden filtreleme yapacagim cekilen urunde.
    func filterProduct(id: Int) {
        for product in HomeViewController.productList {
            if let productId = product.id {
                if productId == id {
                    productImage.sd_setImage(with: URL(string: product.image!), placeholderImage: UIImage(named: "test1.jpg"))
                    productTitle.text = product.title
                    productDescription.text = product.description
                    productSalesCount.text = "\(product.count ?? -1) sold"
                    productRate.text = "⭐️\(product.rate ?? 0)"
                    productPrice.text = "$\(product.price ?? -1)"
                }
            }
        }
    }
}
