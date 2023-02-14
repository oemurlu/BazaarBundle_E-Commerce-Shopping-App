//
//  HomeViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit
import Alamofire
import SDWebImage

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    static var productList: [ProductModel] = []
    static var categoryList: [CategoryModel] = []
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories()
        fetchProducts()
    }
    
    //MARK: - Functions
    func fetchProducts() {
        HomeViewController.productList  = []
        AF.request(K.Network.baseURL).response { response in
            switch response.result {
            case .success(_):
                do {
                    let productData = try JSONDecoder().decode([ProductData].self, from: response.data!)
                    for data in productData {
                        HomeViewController.productList.append(ProductModel(id: data.id, title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate), category: data.category, description: data.description, count: data.rating.count))
                        DispatchQueue.main.async {
                            self.productCollectionView.reloadData()
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
    
    func fetchCategories() {
        AF.request(K.Network.categoriesURL).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let categories = try JSONDecoder().decode([String].self, from: data!)
                    for category in categories {
                        HomeViewController.categoryList.append(CategoryModel(category: category))
                    }
                    DispatchQueue.main.async {
                        self.categoryCollectionView.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print("error on fetchCategories func: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - CollectionCells Setup
    func collectionSetup() {
        categoryCollectionView.register(UINib(nibName: K.CollectionViews.topCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier)
        
        categoryCollectionView.collectionViewLayout = TopCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
        
        
        productCollectionView.register(UINib(nibName: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier)
        
        productCollectionView.collectionViewLayout = BottomCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
    }
    
    //MARK: - Functions
    func changeVCcategoryToTableView(category: String) {
        switch category {
            
        case "electronics":
            let cat = "electronics"
            CategorizedViewController.selectedCategory = cat
            
        case "jewelery":
            let cat = "jewelery"
            CategorizedViewController.selectedCategory = cat
            
        case "men's clothing":
            let cat = "men's%20clothing"
            CategorizedViewController.selectedCategory = cat
            
        case "women's clothing":
            let cat = "women's%20clothing"
            CategorizedViewController.selectedCategory = cat
            
        default:
            DuplicateFuncs.alertMessage(title: "Category Error", message: "", vc: self)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.categoryTableView)
        show(vc, sender: self)
    }
    
    func changeVCHomeToProductDetail(id: Int) {
        ProductDetailViewController.selectedProductID = id
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: K.Segues.productDetailViewController)
        show(vc, sender: self)
    }
}

//MARK: - Extensions
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case categoryCollectionView:
            return HomeViewController.categoryList.count
            
        case productCollectionView:
            return HomeViewController.productList.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier, for: indexPath) as! CategoriesCollectionViewCell
            cell.categoryLabel.text = HomeViewController.categoryList[indexPath.row].category
            return cell
            
        case productCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, for: indexPath) as! ProductsCollectionViewCell
            let u = HomeViewController.productList[indexPath.row]
            cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "cingeneford.png"))
            cell.productNameLabel.text = u.title
            cell.productRateLabel.text = "⭐️ \(u.rate!) "
            cell.productPriceLabe.text = "$\(u.price!)"
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case categoryCollectionView:
            if let category = HomeViewController.categoryList[indexPath.row].category {
                changeVCcategoryToTableView(category: category)
            }
            
        case productCollectionView:
            if let idd = HomeViewController.productList[indexPath.row].id {
                changeVCHomeToProductDetail(id: idd)
            }
            
        default:
            print("error at didSelectItemAt")
            break
        }
    }
}
