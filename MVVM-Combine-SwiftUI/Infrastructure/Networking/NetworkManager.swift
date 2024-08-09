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

    func makeRequest<T: Decodable>(_ request: APIService, output: T.Type) -> AnyPublisher<BaseResponse<T>, NetworkError> {
        var urlString = request.baseURL + request.path
        
        if request.method == .GET, let parameters = request.params, request.parameterEncoding == .url {
            urlString = encodeURL(urlString: urlString, parameters: parameters)
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if request.method != .GET, let parameters = request.params {
            do {
                switch request.parameterEncoding {
                case .json:
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                case .url:
                    let encodedParameters = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                    urlRequest.httpBody = encodedParameters.data(using: .utf8)
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                return Fail(error: NetworkError.invalidParameters).eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                let decoder = JSONDecoder()
                let response = try decoder.decode(BaseResponse<T>.self, from: output.data)

                guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    if let error = response.errors {
                        throw NetworkError.errorResponse(error: error)
                    }
                    throw NetworkError.noData
                }
                debugPrint("aselole network \(response)")

                return response
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.genericError(error: error)
                }
            }
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
