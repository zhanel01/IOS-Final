//
//  ProductCollectionViewCell.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

//
//  ProductCollectionViewCell.swift
//  JEANELLE
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Stored product
    private var product: Product?

    // 👇 ДОБАВЛЯЕМ ЭТО ЧТОБЫ НЕ БЫЛО ОШИБКИ
    var onFavoriteTap: (() -> Void)?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
    }

    // MARK: - Configure Cell
    func configure(with product: Product, isFavorite: Bool) {
        self.product = product

        brandLabel.text = product.brand?.capitalized ?? "Unknown"
        nameLabel.text = product.name
        nameLabel.numberOfLines = 2

        let price = product.priceValue
        priceLabel.text = price == 0 ? "—" : "\(price)$"

        // MARK: - Image loading
        if let urlString = product.imageLink,
           let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }

        updateFavoriteIcon(isFavorite)
    }

    // MARK: - Update heart icon
    private func updateFavoriteIcon(_ isFav: Bool) {
        let imageName = isFav ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFav ? .systemRed : .darkGray
    }

    // MARK: - Favorite button action
    @IBAction func favoriteTapped(_ sender: UIButton) {

        // вызываем замыкание → HomeViewController сам обновит UserDefaults
        onFavoriteTap?()
    }
}
