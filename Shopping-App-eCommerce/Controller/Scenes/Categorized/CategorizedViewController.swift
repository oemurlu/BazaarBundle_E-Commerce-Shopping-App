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
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static var filteredProductList: [ProductModel] = []
    static var selectedCategory: String = ""
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCellSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CategorizedViewController.filteredProductList = []
        fetchCategoryProducts(category: CategorizedViewController.selectedCategory)
        categoryNameLabelSetup(name: CategorizedViewController.selectedCategory)
    }
    
    //MARK: - Functions
    func tableViewCellSetup() {
        tableView.register(UINib(nibName: K.TableView.categorizedTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.categorizedTableViewCell)
    }
    
    func categoryNameLabelSetup(name: String) {
        switch name {
        case "electronics":
            categoryNameLabel.text = "Electronics"
        case "jewelery":
            categoryNameLabel.text = "Jewelery"
        case "men's%20clothing":
            categoryNameLabel.text = "Men's clothing"
        case "women's%20clothing":
            categoryNameLabel.text = "Women's clothing"
        default:
            print("category name error")
        }
    }
    
    func changeVCCategoryToProductDetail(id: Int) {
        ProductDetailViewController.selectedProductID = id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
    }
    
    func fetchCategoryProducts(category: String) {
        print("\(K.Network.categoryURL)/\(category)")
       AF.request("\(K.Network.categoryURL)/\(category)").response { response in
       switch response.result {
       case .success(_):
           do {
               let productData = try JSONDecoder().decode([ProductData].self, from: response.data!)
               for data in productData {
                   CategorizedViewController.filteredProductList.append(ProductModel(id: data.id, title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate), category: data.category, description: data.description, count: data.rating.count))
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               }
               } catch
               let error {
                   print(error)
               }
               case .failure(let error):
               print(error)
           }
       }
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
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(systemName: "photo"))
        return cell
    }
}

extension CategorizedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let productIdAtSelectedRow = CategorizedViewController.filteredProductList[indexPath.row].id {
            changeVCCategoryToProductDetail(id: productIdAtSelectedRow)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
