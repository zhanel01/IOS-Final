//
//  APIService.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}

    enum APIError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case decodingFailed(Error)
    }

    private let baseURLString = "https://makeup-api.herokuapp.com/api/v1/products.json"

    
    func fetchProducts(productType: String? = nil,
                       brand: String? = nil,
                       completion: @escaping (Result<[Product], APIError>) -> Void) {

        var components = URLComponents(string: baseURLString)
        var items: [URLQueryItem] = []

        if let productType, !productType.isEmpty {
            items.append(URLQueryItem(name: "product_type", value: productType))
        }
        if let brand, !brand.isEmpty {
            items.append(URLQueryItem(name: "brand", value: brand))
        }

        if !items.isEmpty { components?.queryItems = items }

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(.requestFailed(error))) }
                return
            }

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
                  let data else {
                DispatchQueue.main.async { completion(.failure(.invalidResponse)) }
                return
            }

            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async { completion(.success(products)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingFailed(error))) }
            }
        }.resume()
    }
}

