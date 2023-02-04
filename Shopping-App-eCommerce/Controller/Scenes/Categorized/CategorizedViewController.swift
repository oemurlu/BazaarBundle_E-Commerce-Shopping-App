//
//  CategorizedTableViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 31.01.2023.
//

import UIKit
import Alamofire
import SDWebImage

class CategorizedViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    static var filteredProductList: [ProductModel] = []
    static var selectedCategory: String = ""
    
    static var denemeId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.TableView.categorizedTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.categorizedTableViewCell)
        filterCategory(category: CategorizedViewController.selectedCategory)
        
    }
    
    
    //MARK: - Functions
    // Tekrardan model yazip API istek gondermek yerine tum urunleri zaten cekmistim. O yuzden filtreleme yapacagim cekilen urunlerde.
    func filterCategory(category: String) {
        CategorizedViewController.filteredProductList = []
        for product in HomeViewController.productList {
            if let productCategory = product.category {
                if productCategory == category {
                    CategorizedViewController.filteredProductList.append(product)
                }
            }
        }
    }
    
    func changeVCCategoryToProductDetail(id: Int) {
        ProductDetailViewController.selectedProductID = id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
        
    }
    
}

//MARK: - Extensions
extension CategorizedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategorizedViewController.filteredProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.categorizedTableViewCell, for: indexPath) as! CategorizedTableViewCell
        let u = CategorizedViewController.filteredProductList[indexPath.row]
        cell.productNameLabel.text = u.title
        cell.productDescriptionLabel.text = u.description
        cell.productRateLabel.text = "⭐️ \(u.rate!) "
        cell.productPriceLabel.text = "\(u.price!)$"
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "cingeneford.png"))
        CategorizedViewController.denemeId = u.id!
        return cell
    }
}

extension CategorizedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(HomeViewController.productList[indexPath.row].price!)
//        if let id = HomeViewController.productList[indexPath.row].id {
        let id = CategorizedViewController.denemeId
            changeVCCategoryToProductDetail(id: id)
    }
}
