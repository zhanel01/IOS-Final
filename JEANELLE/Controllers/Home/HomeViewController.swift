//
//  ViewController.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//bannerImageView.image = UIImage(named: "banner")


import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Data
    private var products: [Product] = []
    private var filteredProducts: [Product] = []

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
        setupSearch()
        loadProducts()
    }

    // MARK: - UI Setup
    private func setupUI() {
        navigationItem.title = "JEANELLE"

        bannerImageView.backgroundColor = .systemPink
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
    }

    // MARK: - CollectionView Setup
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumInteritemSpacing = 12
        layout?.minimumLineSpacing = 12
        layout?.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }

    // MARK: - Search Setup
    private func setupSearch() {
        searchBar.delegate = self
    }

    // MARK: - Load API Data
    private func loadProducts() {
        APIService.shared.fetchProducts(productType: "lipstick") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.products = items
                self.filteredProducts = items
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            case .failure(let error):
                print("API ERROR:", error)
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductCell",
            for: indexPath
        ) as! ProductCollectionViewCell

        let product = filteredProducts[indexPath.item]
        let isFavorite = UserDefaultsManager.shared.isFavorite(product.id)

        cell.configure(with: product, isFavorite: isFavorite)

        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let columns: CGFloat = 2
        let spacing: CGFloat = 12

        let totalSpacing = spacing * (columns + 1)
        let width = (collectionView.bounds.width - totalSpacing) / columns

        let height = width * 1.35   // идеальная пропорция для косметики

        return CGSize(width: width, height: height)
    }
}


// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredProducts = products
        } else {
            let lower = searchText.lowercased()

            filteredProducts = products.filter { product in
                product.name.lowercased().contains(lower) ||
                (product.brand?.lowercased().contains(lower) ?? false)
            }
        }

        collectionView.reloadData()
    }
}
