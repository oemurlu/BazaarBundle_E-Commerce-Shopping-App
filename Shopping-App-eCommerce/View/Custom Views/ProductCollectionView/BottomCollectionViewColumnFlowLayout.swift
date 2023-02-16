//
//  BottomCollectionViewColumnFlowLayout.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 30.01.2023.
//

import UIKit

class BottomCollectionViewColumnFlowLayout: UICollectionViewFlowLayout {
    
    let sutunSayisi: Int
    var yukseklikOrani: CGFloat = (2.6 / 2.0)
    
    init(sutunSayisi: Int, minSutunAraligi: CGFloat = 0, minSatirAraligi: CGFloat = 0) {
        self.sutunSayisi = sutunSayisi
        super.init()
        
        self.minimumInteritemSpacing = minSutunAraligi
        self.minimumLineSpacing = minSatirAraligi
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let araliklar = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(sutunSayisi - 1)
        
        let elemaninGenisligi = (collectionView.bounds.size.width - araliklar) / CGFloat(sutunSayisi).rounded(.down)
        let elemaninYuksekligi = elemaninGenisligi * yukseklikOrani
        
        itemSize = CGSize(width: elemaninGenisligi, height: elemaninYuksekligi)
        
    }
    
    
}

//extension BottomCollectionViewColumnFlowLayout: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//    }
//}
