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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.TableView.categorizedTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.categorizedTableViewCell)
        print("SCNAME (viewdidload): \(CategorizedViewController.selectedCategory)")
        filterCategory(category: CategorizedViewController.selectedCategory)

    }
}

//MARK: - Functions
// networksuz deneme.
func filterCategory(category: String) {
    //    let homeObj = HomeViewController()
    //    let categoryObj = CategorizedViewController()
    CategorizedViewController.filteredProductList = []
    for product in HomeViewController.productList {
        if let productCategory = product.category {
        print("pc", productCategory)
            print("c", category)
        if productCategory == category {
            print("ASD", product)
            CategorizedViewController.filteredProductList.append(product)
        }
    }
    }
}


extension CategorizedViewController: UITableViewDelegate {
    //didSelectRowAt
}

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
        return cell
    }
}
