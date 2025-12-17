//
//  CartViewController.swift
//  JEANELLE
//
//  Created by Zhanel on 18.12.2025.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToPaymentButton: UIButton!


    private var cartItems: [CartItem] = []

 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cart"
        setupTableView()
        setupUI()
        loadCart()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCart()
    }


    private func setupUI() {
        goToPaymentButton.layer.cornerRadius = 12
        goToPaymentButton.isEnabled = !cartItems.isEmpty
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }


    private func loadCart() {
        cartItems = UserDefaultsManager.shared.loadCart()
        goToPaymentButton.isEnabled = !cartItems.isEmpty
        tableView.reloadData()
    }

    @IBAction func goToPaymentTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(
            withIdentifier: "PaymentViewController"
        ) as! PaymentViewController

        navigationController?.pushViewController(vc, animated: true)
    }
}


extension CartViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CartCell",
            for: indexPath
        ) as! CartTableViewCell

        let item = cartItems[indexPath.row]
        cell.configure(with: item)

        cell.onPlus = { [weak self] in
            guard let self else { return }
            UserDefaultsManager.shared.updateQuantity(
                productId: item.product.id,
                newQuantity: item.quantity + 1
            )
            self.loadCart()
        }

        cell.onMinus = { [weak self] in
            guard let self else { return }

            if item.quantity > 1 {
                UserDefaultsManager.shared.updateQuantity(
                    productId: item.product.id,
                    newQuantity: item.quantity - 1
                )
            } else {
                UserDefaultsManager.shared.removeFromCart(
                    productId: item.product.id
                )
            }
            self.loadCart()
        }

        cell.onDelete = { [weak self] in
            guard let self else { return }
            UserDefaultsManager.shared.removeFromCart(
                productId: item.product.id
            )
            self.loadCart()
        }

        return cell
    }
}


extension CartViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
