//
//  HomeViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 27.01.2023.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var liste = ["Electronic", "Jewelery", "Men's Clothing", "Women's Clothing"]
    var urunListesi: [Urun] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionSetup()
        urunOlustur() //TEST

        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    //MARK: - urun olustur
    func urunOlustur() {
        
        //TEST ITEMS
        var u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        u = Urun(title: "uzun kollu v yaka body erkek harika ", price: 239.99, image: "test1.jpg", rate: 4.8)
        urunListesi.append(u)
        
    }
    
    
    
    //MARK: - CollectionCells Setup
    private func collectionSetup() {
        topCollectionView.register(UINib(nibName: K.topCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.topCollectionViewNibNameAndIdentifier)
        
        topCollectionView.collectionViewLayout = TopCollectionViewColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 5)
        
        
        bottomCollectionView.register(UINib(nibName: K.bottomCollectionViewNibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: K.bottomCollectionViewNibNameAndIdentifier)
        
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
            return urunListesi.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.topCollectionViewNibNameAndIdentifier, for: indexPath) as! CategoriesCollectionViewCell
            cell.categoryLabel.text = liste[indexPath.row]
            return cell
        case bottomCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.bottomCollectionViewNibNameAndIdentifier, for: indexPath) as! ProductsCollectionViewCell
            let u = urunListesi[indexPath.row]
            cell.productImageView.image = UIImage(named: u.image!)
            cell.productNameLabel.text = u.title
            cell.productRateLabel.text = "⭐️ \(u.rate!) "
            cell.productPriceLabe.text = "\(u.price!)$"
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
