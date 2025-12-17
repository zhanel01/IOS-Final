//
//  CartTableViewCell.swift
//  JEANELLE
//
//  Created by Zhanel  on 18.12.2025.
//

import UIKit
import Kingfisher

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    var onPlus: (() -> Void)?
    var onMinus: (() -> Void)?
    var onDelete: (() -> Void)?

    func configure(with item: CartItem) {
        nameLabel.text = item.product.name
        quantityLabel.text = "\(item.quantity)"

        let price = item.product.priceValue * Double(item.quantity)
        priceLabel.text = "\(price)$"

        if let urlStr = item.product.imageLink,
           let url = URL(string: urlStr) {
            productImageView.kf.setImage(with: url)
        }
    }

    @IBAction func plusTapped(_ sender: UIButton) {
        onPlus?()
    }

    @IBAction func minusTapped(_ sender: UIButton) {
        onMinus?()
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        onDelete?()
    }
}
