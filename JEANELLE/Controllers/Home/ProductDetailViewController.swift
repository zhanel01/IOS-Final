//
//  ProductDetailViewController.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!

    var product: Product!
    private var quantity: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fillData()
        updateFavoriteUI()
        updateCartUI()
    }

    private func setupUI() {
        quantityStackView?.isHidden = true
        addToCartButton?.isHidden = false
        descriptionTextView?.isEditable = false
    }

    private func fillData() {
        brandLabel.text = product.brand?.capitalized ?? "Unknown"
        nameLabel.text = product.name
        nameLabel.numberOfLines = 2

        let price = product.priceValue
        priceLabel.text = price == 0 ? "—" : "\(price)$"

        if let urlString = product.imageLink, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        descriptionTextView.text =
            product.productDescription?.isEmpty == false
            ? product.productDescription
            : "No description available."
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.toggleFavorite(product)
        updateFavoriteUI()
    }

    private func updateFavoriteUI() {
        let isFav = UserDefaultsManager.shared.isFavorite(product.id)
        let image = UIImage(systemName: isFav ? "heart.fill" : "heart")
        favoriteButton?.setImage(image, for: .normal)
        favoriteButton?.tintColor = isFav ? .systemRed : .darkGray
    }

    @IBAction func addToCartTapped(_ sender: UIButton) {
        quantity = 1
        UserDefaultsManager.shared.addToCart(product)
        updateCartUI()
    }

    @IBAction func minusTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            UserDefaultsManager.shared.updateQuantity(productId: product.id, newQuantity: quantity)
        } else {
            quantity = 0
            UserDefaultsManager.shared.removeFromCart(productId: product.id)
        }
        updateCartUI()
    }

    @IBAction func plusTapped(_ sender: UIButton) {
        quantity += 1
        UserDefaultsManager.shared.updateQuantity(productId: product.id, newQuantity: quantity)
        updateCartUI()
    }

    private func updateCartUI() {
        let cart = UserDefaultsManager.shared.loadCart()
        quantity = cart.first(where: { $0.product.id == product.id })?.quantity ?? 0

        if quantity == 0 {
            addToCartButton?.isHidden = false
            quantityStackView?.isHidden = true
        } else {
            addToCartButton?.isHidden = true
            quantityStackView?.isHidden = false
            quantityLabel?.text = "\(quantity)"
        }
    }
}
