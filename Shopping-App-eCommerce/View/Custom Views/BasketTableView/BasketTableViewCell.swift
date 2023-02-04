//
//  BasketTableViewCell.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 4.02.2023.
//

import UIKit

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productImageLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    var quantity = 1
    
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
        quantity -= 1
        productQuantity.text = "\(quantity)"
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        quantity += 1
        productQuantity.text = "\(quantity)"
    }
    
}
