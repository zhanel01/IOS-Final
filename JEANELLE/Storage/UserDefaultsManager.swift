import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let favorites = "jeanelle_favorites_products"
        static let cart = "jeanelle_cart_items"
        static let profileName = "jeanelle_profile_name"
        static let profileEmail = "jeanelle_profile_email"
    }

    // MARK: - Favorites

    func loadFavorites() -> [Product] {
        guard let data = defaults.data(forKey: Keys.favorites) else { return [] }
        return (try? JSONDecoder().decode([Product].self, from: data)) ?? []
    }

    func saveFavorites(_ products: [Product]) {
        let data = try? JSONEncoder().encode(products)
        defaults.set(data, forKey: Keys.favorites)
    }

    func toggleFavorite(_ product: Product) {
        var favs = loadFavorites()
        if let idx = favs.firstIndex(where: { $0.id == product.id }) {
            favs.remove(at: idx)
        } else {
            favs.append(product)
        }
        saveFavorites(favs)
    }

    func isFavorite(_ productId: Int) -> Bool {
        loadFavorites().contains(where: { $0.id == productId })
    }

    // Новый метод — возвращает все избранные продукты
    func getFavoriteProducts() -> [Product] {
        return loadFavorites()
    }

    // MARK: - Cart

    func loadCart() -> [CartItem] {
        guard let data = defaults.data(forKey: Keys.cart) else { return [] }
        return (try? JSONDecoder().decode([CartItem].self, from: data)) ?? []
    }

    func saveCart(_ items: [CartItem]) {
        let data = try? JSONEncoder().encode(items)
        defaults.set(data, forKey: Keys.cart)
    }

    func addToCart(_ product: Product) {
        var cart = loadCart()
        if let idx = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[idx].quantity += 1
        } else {
            cart.append(CartItem(product: product, quantity: 1))
        }
        saveCart(cart)
    }

    func updateQuantity(productId: Int, newQuantity: Int) {
        var cart = loadCart()
        guard let idx = cart.firstIndex(where: { $0.product.id == productId }) else { return }

        if newQuantity <= 0 {
            cart.remove(at: idx)
        } else {
            cart[idx].quantity = newQuantity
        }
        saveCart(cart)
    }

    func removeFromCart(productId: Int) {
        var cart = loadCart()
        cart.removeAll { $0.product.id == productId }
        saveCart(cart)
    }

    func cartTotal() -> Double {
        loadCart().reduce(0) { $0 + $1.lineTotal }
    }

    func clearCart() {
        saveCart([])
    }

    // MARK: - Profile

    func saveProfile(name: String, email: String) {
        defaults.set(name, forKey: Keys.profileName)
        defaults.set(email, forKey: Keys.profileEmail)
    }

    func loadProfile() -> (name: String, email: String) {
        let name = defaults.string(forKey: Keys.profileName) ?? ""
        let email = defaults.string(forKey: Keys.profileEmail) ?? ""
        return (name, email)
    }

    func logoutClearAll() {
        defaults.removeObject(forKey: Keys.favorites)
        defaults.removeObject(forKey: Keys.cart)
        defaults.removeObject(forKey: Keys.profileName)
        defaults.removeObject(forKey: Keys.profileEmail)
    }
}
