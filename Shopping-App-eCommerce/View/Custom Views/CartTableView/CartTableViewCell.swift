//
//  CartTableViewCell.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 4.02.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var quantity = 1 {
        didSet {
            if quantity <= 1 {
                quantity = 1
            } else if quantity > 10 {
                quantity = 10
            }
//            self.productQuantity.text = String(quantity)
        }
    }
    
    let obj = CartViewController()
    
    let database = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantity = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
//        quantity -= 1
        addTarget()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
//        quantity += 1
        addTarget()
    }
    
    func addTarget() {
        plusButton.addTarget(self, action: #selector(stepperPlusButtonPressed), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(stepperMinusButtonPressed), for: .touchUpInside)
    }
    
    @objc func stepperPlusButtonPressed(_ button: UIButton) {
        quantity = quantity + 1
        print("stepper +1")
    }
    
    @objc func stepperMinusButtonPressed(_ button: UIButton) {
        quantity = quantity - 1
        print("stepper -1")
    }
  

    
    
}

