//
//  ProfileViewController.swift
//  JEANELLE
//
//  Created by Zhanel  on 18.12.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"

        setupAvatar()
        loadProfile()
        loadStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
        loadStats()
    }



    private func setupAvatar() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tap)
    }

    private func loadProfile() {
        let profile = UserDefaultsManager.shared.loadProfile()
        nameLabel.text = profile.name.isEmpty ? "Zhanel" : profile.name
        emailLabel.text = profile.email.isEmpty ? "Zhumanova@qmail.com" : profile.email

        if let imageData = UserDefaults.standard.data(forKey: "profile_avatar") {
            avatarImageView.image = UIImage(data: imageData)
        }
    }

    private func loadStats() {
        let favoritesCount = UserDefaultsManager.shared.getFavoriteProducts().count
        let cartCount = UserDefaultsManager.shared.loadCart().count

        favoritesLabel.text = "Favorites: \(favoritesCount)"
        cartLabel.text = "Cart items: \(cartCount)"
    }

  
    @IBAction func logoutTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.logoutClearAll()

        nameLabel.text = "—"
        emailLabel.text = "—"
        favoritesLabel.text = "Favorites: 0"
        cartLabel.text = "Cart items: 0"
        avatarImageView.image = UIImage(systemName: "person.circle")
    }

    @objc private func avatarTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        if let image = info[.originalImage] as? UIImage {
            avatarImageView.image = image

            if let data = image.jpegData(compressionQuality: 0.8) {
                UserDefaults.standard.set(data, forKey: "profile_avatar")
            }
        }
    }
}
