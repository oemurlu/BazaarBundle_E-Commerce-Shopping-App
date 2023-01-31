//
//  HomeViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit
import Alamofire


class HomeViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var liste = ["Electronic", "Jewelery", "Men's Clothing", "Women's Clothing"]
    var urunListesi: [ProductModel] = []
//    var propertyList =  [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        urunOlustur() //TEST ICIN
        fetchProducts()
        collectionSetup()
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    
    //MARK: - Networking
    func fetchProducts() {
        AF.request(K.Network.baseURL).response { response in
        switch response.result {
        case .success(_):
            do {
                let productData = try JSONDecoder().decode([ProductData].self, from: response.data!)
                for data in productData {
                    self.urunListesi.append(ProductModel(title: data.title, price: Float(data.price), image: data.image, rate: Float(data.rating.rate)))
                    DispatchQueue.main.async {
                        self.bottomCollectionView.reloadData()
                    }
                }
                //TODO: reload collectionView or tableView with products data
                } catch
                let error {
                    print(error)
                }
                case .failure(let error):
                print(error)
            }
        }
    }



    
    //MARK: - urun olustur
    func urunOlustur() {
        
        //TEST ITEMS
        var u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = ProductModel(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        
    }
    
    
    
    //MARK: - CollectionCells Setup
    private func collectionSetup() {
        topCollectionView.register(UINib(nibName: K.CollectionViews.topCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.topCollectionViewNibNameAndIdentifier)
        
        topCollectionView.collectionViewLayout = TopCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
        
        
        bottomCollectionView.register(UINib(nibName: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.CollectionViews.bottomCollectionViewNibNameAndIdentifier)
        
        bottomCollectionView.collectionViewLayout = BottomCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
    }
    
    
    
}

//MARK: - Extensions
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topCollectionView:
            return liste.count
        case bottomCollectionView:
            print(urunListesi.count)
            return urunListesi.count
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
            let u = urunListesi[indexPath.row]
            cell.productImageView.image = UIImage(named: "test1.jpg")
            cell.productNameLabel.text = u.title
            cell.productRateLabel.text = "⭐️ \(u.rate!) "
            cell.productPriceLabe.text = "\(u.price!)$"
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
