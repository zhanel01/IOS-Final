//
//  HomeViewController.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//


import UIKit

class HomeViewController: UIViewController {

   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    
    private var products: [Product] = []
    private var filteredProducts: [Product] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
        setupSearch()
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    
    

    private func setupUI() {
        navigationItem.title = "JEANELLE"

        bannerImageView.image = UIImage(named: "banner")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
    }

 
    private func setupCollectionView() {
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = .zero
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupSearch() {
        searchBar.delegate = self
    }

    
    private func loadProducts() {
        APIService.shared.fetchProducts(productType: "lipstick") { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.products = items
                self.filteredProducts = items
                self.collectionView.reloadData()

            case .failure(let error):
                print("API ERROR:", error)
            }
        }
    }
}


extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductCell",
            for: indexPath
        ) as! ProductCollectionViewCell

        let product = filteredProducts[indexPath.item]
        let isFavorite = UserDefaultsManager.shared.isFavorite(product.id)

        cell.configure(with: product, isFavorite: isFavorite)

        cell.onFavoriteTap = { [weak self] in
            guard let self = self else { return }
            UserDefaultsManager.shared.toggleFavorite(product)
            self.collectionView.reloadItems(at: [indexPath])
        }

        return cell
    }
}



extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        let product = filteredProducts[indexPath.item]

        let vc = storyboard?.instantiateViewController(
            withIdentifier: "ProductDetailViewController"
        ) as! ProductDetailViewController

        vc.product = product
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension HomeViewController: UICollectionViewDelegateFlowLayout {

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
