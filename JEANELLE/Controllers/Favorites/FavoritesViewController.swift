//
//  FavoritesViewController.swift
//  JEANELLE
//
//  Created by Zhanel on 17.12.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

   
    @IBOutlet weak var collectionView: UICollectionView!

   
    private var favoriteProducts: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        setupCollectionView()
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        collectionView.reloadData()
    }

    private func loadFavorites() {
        favoriteProducts = UserDefaultsManager.shared.getFavoriteProducts()
    }

    private func setupCollectionView() {
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = .zero
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


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

        cell.onFavoriteTap = { [weak self] in
            guard let self = self else { return }
            UserDefaultsManager.shared.toggleFavorite(product)
            self.loadFavorites()
            self.collectionView.reloadData()
        }

        return cell
    }
}



extension FavoritesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let product = favoriteProducts[indexPath.item]

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "ProductDetailViewController"
        ) as! ProductDetailViewController

        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FavoritesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 12
        let width = (collectionView.bounds.width - spacing * 3) / 2

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
