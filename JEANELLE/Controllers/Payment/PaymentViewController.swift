//
//  PaymentViewController.swift
//  JEANELLE
//
//  Created by Zhanel on 18.12.2025.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!

    private var cartItems: [CartItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Payment"
        loadCart()
        setupUI()
        calculateTotal()
    }

    private func setupUI() {
        payButton.layer.cornerRadius = 12
    }

    private func loadCart() {
        cartItems = UserDefaultsManager.shared.loadCart()
    }

    private func calculateTotal() {
        let total = cartItems.reduce(0) {
            $0 + ($1.product.priceValue * Double($1.quantity))
        }

        totalLabel.text = "Total: \(total)$"
    }

    @IBAction func payTapped(_ sender: UIButton) {
        print("💳 Payment started")

        let alert = UIAlertController(
            title: "Success",
            message: "Payment completed 🎉",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            UserDefaultsManager.shared.clearCart()
            self.navigationController?.popToRootViewController(animated: true)
        })

        present(alert, animated: true)
    }
}
