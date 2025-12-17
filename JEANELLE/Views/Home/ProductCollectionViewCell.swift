//
//  ProductCollectionViewCell.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    private var currentImageURL: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        currentImageURL = nil
        favoriteButton.isSelected = false
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.secondarySystemBackground

        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true

        brandLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        brandLabel.textColor = .secondaryLabel

        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 2

        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        priceLabel.textColor = .systemPink

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.tintColor = .systemPink
        favoriteButton.isUserInteractionEnabled = false // логику добавим позже
    }

    // MARK: - Configure

    func configure(with product: Product, isFavorite: Bool) {
        brandLabel.text = product.brand?.uppercased() ?? "UNKNOWN"
        nameLabel.text = product.name

        if let price = product.price, !price.isEmpty {
            priceLabel.text = "\(price) \(product.currency ?? "$")"
        } else {
            priceLabel.text = "—"
        }

        favoriteButton.isSelected = isFavorite

        loadImage(from: product.imageLink)
    }

    // MARK: - Image loading

    private func loadImage(from urlString: String?) {
        productImageView.image = nil
        guard let urlString, let url = URL(string: urlString) else { return }

        currentImageURL = urlString

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self = self,
                let data,
                let image = UIImage(data: data),
                self.currentImageURL == urlString
            else { return }

            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }.resume()
    }
}

