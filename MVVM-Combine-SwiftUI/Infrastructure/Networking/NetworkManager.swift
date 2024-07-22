//
//  NetworkManager.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import Foundation
import Combine

public class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let session = URLSession.shared
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case PATCH
        case DELETE
    }
    
    enum EncodingType {
        case url
        case json
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case noData
        case invalidParameters
    }
    
    func makeRequest(
        urlString: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: EncodingType = .json
    ) -> AnyPublisher<Data, Error> {
        var urlString = urlString
        
        if method == .GET, let parameters = parameters, encoding == .url {
            urlString = encodeURL(urlString: urlString, parameters: parameters)
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method != .GET, let parameters = parameters {
            do {
                switch encoding {
                case .json:
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .url:
                    let encodedParameters = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                    request.httpBody = encodedParameters.data(using: .utf8)
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
            } catch let error {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func downloadRequest(
        urlString: String
    ) -> AnyPublisher<URL, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.downloadTaskPublisher(for: url)
            .tryMap { output in
                return output.url
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func uploadRequest(
        urlString: String, 
        data: Data
    ) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        return session.uploadTaskPublisher(for: request, from: data)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return output.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func encodeURL(
        urlString: String,
        parameters: [String: Any]
    ) -> String {
        guard var components = URLComponents(string: urlString) else {
            return urlString
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        return components.url?.absoluteString ?? urlString
    }
}
