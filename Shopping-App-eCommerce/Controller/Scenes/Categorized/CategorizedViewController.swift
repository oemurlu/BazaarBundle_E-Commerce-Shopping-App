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
//        filterCategory(category: CategorizedViewController.selectedCategory)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        CategorizedViewController.filteredProductList = []
        fetchCategoryProducts(category: CategorizedViewController.selectedCategory)
    }
    
    
    //MARK: - Functions
    func changeVCCategoryToProductDetail(id: Int) {
        print("ESKI ID: ",ProductDetailViewController.selectedProductID)
        ProductDetailViewController.selectedProductID = id
        print("YENI ID: ",ProductDetailViewController.selectedProductID)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
        
    }
    
    //MARK: - Networking
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
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "cingeneford.png"))
//        CategorizedViewController.denemeId = u.id!
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