//
//  HomeViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit
import Alamofire
import SDWebImage
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
  
    //MARK: - Properties
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var liste = ["electronics", "jewelery", "men's clothing", "women's clothing"] //bad code
    static var productList: [ProductModel] = []
    
    let db = Firestore.firestore()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchProducts()
    }

    //MARK: - Networking
     func fetchProducts() {
        HomeViewController.productList  = []
        AF.request(K.Network.baseURL).response { response in
        switch response.result {
        case .success(_):
            do {
                let productData = try JSONDecoder().decode([ProductData].self, from: response.data!)
                for data in productData {
                    //topVC
                    
                    //bottomVC
                    HomeViewController.productList.append(ProductModel(id: data.id, title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate), category: data.category, description: data.description, count: data.rating.count))
                    DispatchQueue.main.async {
                        self.bottomCollectionView.reloadData()
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
    
    //MARK: - CollectionCells Setup
    private func collectionSetup() {
        topCollectionView.register(UINib(nibName: K.CollectionViews.topCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier)
        
        topCollectionView.collectionViewLayout = TopCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
        
        
        bottomCollectionView.register(UINib(nibName: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier)
        
        bottomCollectionView.collectionViewLayout = BottomCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
    }
    
    //MARK: - Functions
    func changeVCcategoryToTableView(category: String) {
        CategorizedViewController.selectedCategory = category
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
        case topCollectionView:
            return liste.count
        case bottomCollectionView:
            return HomeViewController.productList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier, for: indexPath) as! CategoriesCollectionViewCell
            cell.categoryLabel.text = liste[indexPath.row]
            return cell
        case bottomCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, for: indexPath) as! ProductsCollectionViewCell
            let u = HomeViewController.productList[indexPath.row]
            cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "cingeneford.png"))
            cell.productNameLabel.text = u.title
            cell.productRateLabel.text = "⭐️ \(u.rate!) "
            cell.productPriceLabe.text = "\(u.price!)$"
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case topCollectionView:
            switch indexPath.row {
            case 0:
                changeVCcategoryToTableView(category: "electronics")
            case 1:
                changeVCcategoryToTableView(category: "jewelery")
            case 2:
                changeVCcategoryToTableView(category: "men's%20clothing")
            case 3:
                changeVCcategoryToTableView(category: "women's%20clothing")
            default:
                break
            }
        case bottomCollectionView:
//            print(HomeViewController.productList[indexPath.row].price!)
            if let idd = HomeViewController.productList[indexPath.row].id {
                changeVCHomeToProductDetail(id: idd)
        }
        default:
            break
        }
    }
}
