//
//  FavoritesViewController.swift
//  JEANELLE
//
//  Created by Zhanel on 17.12.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Data
    private var favoriteProducts: [Product] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        setupCollectionView()
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()      // обновлять каждый раз
        collectionView.reloadData()
    }

    // MARK: - Load favorites
    private func loadFavorites() {
        favoriteProducts = UserDefaultsManager.shared.getFavoriteProducts()
    }

    // MARK: - Collection setup
    private func setupCollectionView() {
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = .zero
        }

        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductCell",
            for: indexPath
        ) as! ProductCollectionViewCell

        let product = favoriteProducts[indexPath.item]
        let isFavorite = UserDefaultsManager.shared.isFavorite(product.id)

        cell.configure(with: product, isFavorite: isFavorite)

        // удаление из избранного
        cell.onFavoriteTap = { [weak self] in
            guard let self else { return }

            UserDefaultsManager.shared.toggleFavorite(product)
            self.loadFavorites()
            self.collectionView.reloadData()
        }

        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout (2 колонки)
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 12
        let totalSpacing = spacing * 3
        let width = (collectionView.bounds.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.6)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
